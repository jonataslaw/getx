# Contributing to GetX

Bug reports, documentation, translations, tests, and code improvements are welcome.
Use the issue templates for reports and feature requests. Before starting a fix,
check existing issues and pull requests for related work.

## Preparing a pull request

- Keep the change focused and explain the problem and resulting behavior. Link
  a related issue when one exists; an issue is not required for every contribution.
- Preserve GetX's public contracts and follow the surrounding implementation.
  Explain changes to APIs, defaults, controller ownership, or route behavior, and
  provide migration instructions for breaking changes.
- For a bug fix, add a focused regression test and verify that it fails before
  the fix and passes afterward. Explain when tests do not apply; maintainers
  decide exemptions.
- Update relevant `///` API documentation and the English README when behavior
  or usage changes. Explain when a documentation update is unnecessary.
- Use the PR template. Report the SDK versions, exact checks run, results, and
  remaining limitations. Do not describe pending CI as a successful test run.
- If you use AI assistance, follow the [AI contribution guidelines](CONTRIBUTING.ai.md).

## Local checks

The `master` workflow uses Flutter 3.47.8 for analysis and formatting and tests
the root package on Flutter 3.47.8 and 3.47.9. Respect the SDK constraints in the
branch's `pubspec.yaml`; other release branches may need different SDKs.

```sh
flutter pub get
bash .github/scripts/check-format.sh origin/master
flutter analyze --no-pub --no-fatal-warnings
flutter test --no-pub --coverage
flutter test --no-pub --platform chrome test/rx/rx_workers_test.dart test/instance/get_instance_test.dart
python3 .github/scripts/summarize-coverage.py coverage/lcov.info
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s .github/tests -v
```

Fetch `origin/master` before comparing formatting. The format check uses the
merge base and checks committed, added or modified Dart files, including renamed
files, without rewriting them. Format your working changes before committing
with `dart format path/to/changed_file.dart`. Existing unrelated files are not
part of this gate.

Analyzer errors and info diagnostics fail CI. Warnings are visible but currently
non-fatal, preserving the existing warning policy. The browser job is a scoped
Rx/worker and dependency-injection smoke test, not the entire suite or all web
navigation behavior. Root tests do not run independent example packages; test
affected examples separately.

Coverage describes lines in the recorded files, not necessarily the entire
library. CI preserves the LCOV artifact and writes a summary. Codecov upload is
informational and depends on the repository's tokenless upload configuration.

## Review

Checklists are author acknowledgements; they do not prove correctness. Automated
reviews provide suggestions. Human reviewers make the final decision and may
request additional tests or changes. Verify that feedback was addressed before
reporting it as resolved.

Repository administrators can enable the accompanying review service and merge
rules using the [maintainer setup guide](.github/maintainers/pr-quality.md).
