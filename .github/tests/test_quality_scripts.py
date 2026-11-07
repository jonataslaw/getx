"""Regression checks for the PR quality helpers; uses only the standard library."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"


class FormatCheckTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name)
        self.git("init", "--quiet")
        (self.repo / ".git/info/exclude").write_text("/bin/\n/dart-arguments.json\n")
        self.git("config", "user.email", "test@example.invalid")
        self.git("config", "user.name", "Quality helper test")
        self.write("README.md", "Initial fixture\n")
        self.commit("base")
        self.base = self.git("rev-parse", "HEAD").stdout.strip()
        self.bin = self.repo / "bin"
        self.bin.mkdir()
        fake_dart = self.bin / "dart"
        fake_dart.write_text(
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "from pathlib import Path\n"
            "Path(os.environ['DART_ARGUMENTS']).write_text(json.dumps(sys.argv[1:]))\n"
            "sys.exit(int(os.environ.get('DART_EXIT', '0')))\n"
        )
        fake_dart.chmod(0o755)
        self.arguments = self.repo / "dart-arguments.json"

    def git(self, *args):
        return subprocess.run(
            ["git", *args], cwd=self.repo, text=True, capture_output=True, check=True
        )

    def write(self, name, content="void main() {}\n"):
        path = self.repo / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)

    def commit(self, message):
        self.git("add", "--all")
        self.git("commit", "--quiet", "-m", message)

    def run_check(self, *refs, dart_exit=0):
        environment = os.environ.copy()
        environment.update(
            PATH=str(self.bin) + os.pathsep + environment["PATH"],
            DART_ARGUMENTS=str(self.arguments),
            DART_EXIT=str(dart_exit),
        )
        return subprocess.run(
            ["bash", str(SCRIPTS / "check-format.sh"), *refs],
            cwd=self.repo,
            env=environment,
            text=True,
            capture_output=True,
        )

    def test_paths_with_spaces_newlines_and_leading_dash_are_preserved(self):
        names = ["lib/with space.dart", "lib/with\nnewline.dart", "-leading.dart"]
        for name in names:
            self.write(name)
        self.write("docs/change.md", "Not Dart\n")
        self.commit("Dart changes")
        result = self.run_check(self.base)
        self.assertEqual(result.returncode, 0, result.stderr)
        args = json.loads(self.arguments.read_text())
        self.assertEqual(args[:4], ["format", "--output=none", "--set-exit-if-changed", "--"])
        self.assertCountEqual(args[4:], names)

    def test_deleted_files_are_ignored_and_renamed_destination_is_checked(self):
        self.write("lib/deleted.dart")
        self.write("lib/old.dart", "void oldName() {}\n")
        self.commit("existing Dart")
        base = self.git("rev-parse", "HEAD").stdout.strip()
        self.git("rm", "lib/deleted.dart")
        self.git("mv", "lib/old.dart", "lib/new name.dart")
        self.commit("delete and rename")
        result = self.run_check(base, "HEAD")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(self.arguments.read_text())[4:], ["lib/new name.dart"])

    def test_non_dart_changes_do_not_invoke_formatter(self):
        self.write("README.md", "Documentation change\n")
        self.commit("docs")
        result = self.run_check(self.base)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.arguments.exists())

    def test_formatter_failure_is_propagated(self):
        self.write("lib/unformatted.dart")
        self.commit("Dart change")
        self.assertEqual(self.run_check(self.base, dart_exit=7).returncode, 7)

    def test_invalid_or_option_like_ref_fails_without_running_formatter(self):
        for ref in ["does-not-exist", "--help"]:
            with self.subTest(ref=ref):
                result = self.run_check(ref)
                self.assertNotEqual(result.returncode, 0)
                self.assertFalse(self.arguments.exists())

    def test_explicit_head_ref_limits_the_checked_commit(self):
        self.write("lib/first.dart")
        self.commit("first")
        first = self.git("rev-parse", "HEAD").stdout.strip()
        self.write("lib/second.dart")
        self.commit("second")
        result = self.run_check(self.base, first)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(self.arguments.read_text())[4:], ["lib/first.dart"])

    def test_diverged_base_uses_common_ancestor(self):
        self.write("lib/base_only.dart")
        self.commit("base branch advances")
        advanced_base = self.git("rev-parse", "HEAD").stdout.strip()
        self.git("checkout", "--quiet", "-b", "feature", self.base)
        self.write("lib/feature.dart")
        self.commit("feature branch change")
        result = self.run_check(advanced_base)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(self.arguments.read_text())[4:], ["lib/feature.dart"])

    def test_git_diff_failure_is_propagated(self):
        real_git = shutil.which("git")
        fake_git = self.bin / "git"
        fake_git.write_text(
            "#!/usr/bin/env python3\n"
            "import os, sys\n"
            "if sys.argv[1] == 'diff':\n"
            "    sys.exit(9)\n"
            f"os.execv({real_git!r}, [{real_git!r}, *sys.argv[1:]])\n"
        )
        fake_git.chmod(0o755)
        result = self.run_check(self.base)
        self.assertEqual(result.returncode, 9)
        self.assertFalse(self.arguments.exists())

    def test_missing_arguments_report_usage(self):
        result = self.run_check()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Usage", result.stderr)


class CoverageSummaryTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.report = self.directory / "lcov.info"
        self.summary = self.directory / "summary.md"

    def run_summary(self, content, summary=False):
        self.report.write_text(content)
        environment = os.environ.copy()
        environment.pop("GITHUB_STEP_SUMMARY", None)
        if summary:
            environment["GITHUB_STEP_SUMMARY"] = str(self.summary)
        return subprocess.run(
            [sys.executable, str(SCRIPTS / "summarize-coverage.py"), str(self.report)],
            env=environment,
            text=True,
            capture_output=True,
        )

    def test_valid_report_summarizes_only_recorded_files(self):
        result = self.run_summary(
            "SF:lib/a.dart\nDA:1,2\nDA:2,0\nLF:2\nLH:1\nend_of_record\n"
            "SF:lib/b.dart\nDA:7,1\nLF:1\nLH:1\nend_of_record\n",
            summary=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("66.67%", result.stdout)
        self.assertIn("2/3", result.stdout)
        self.assertIn("2 recorded files", result.stdout)
        self.assertIn("not whole-project coverage", self.summary.read_text())

    def test_repeated_file_records_merge_line_hits(self):
        result = self.run_summary(
            "SF:lib/a.dart\nDA:1,0\nDA:2,1\nend_of_record\n"
            "SF:lib/a.dart\nDA:1,1\nDA:2,0\nend_of_record\n"
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("100.00%", result.stdout)
        self.assertIn("2/2", result.stdout)
        self.assertIn("1 recorded files", result.stdout)

    def test_empty_or_line_free_report_is_rejected(self):
        for content in ["", "TN:test\n", "SF:lib/empty.dart\nLF:0\nLH:0\nend_of_record\n"]:
            with self.subTest(content=content):
                self.assertNotEqual(self.run_summary(content).returncode, 0)

    def test_malformed_records_and_inconsistent_counts_are_rejected(self):
        records = [
            "SF:lib/a.dart\nDA:1,nope\nend_of_record\n",
            "SF:lib/a.dart\nDA:0,1\nend_of_record\n",
            "SF:lib/a.dart\nDA:1,-1\nend_of_record\n",
            "SF:lib/a.dart\nDA:1,1\nLF:2\nend_of_record\n",
            "SF:lib/a.dart\nDA:1,1\nLH:0\nend_of_record\n",
            "SF:lib/a.dart\nDA:1,1\nDA:1,0\nend_of_record\n",
            "DA:1,1\nend_of_record\n",
            "SF:\nDA:1,1\nend_of_record\n",
            "SF:lib/a.dart\nDA:1,1\n",
        ]
        for content in records:
            with self.subTest(content=content):
                result = self.run_summary(content, summary=True)
                self.assertNotEqual(result.returncode, 0)
                self.assertFalse(self.summary.exists())

    def test_missing_file_fails_with_a_clear_error(self):
        result = subprocess.run(
            [sys.executable, str(SCRIPTS / "summarize-coverage.py"), str(self.report)],
            text=True,
            capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("coverage", result.stderr.lower())


if __name__ == "__main__":
    unittest.main()
