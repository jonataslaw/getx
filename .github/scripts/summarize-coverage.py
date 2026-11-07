#!/usr/bin/env python3
"""Validate LCOV and report line coverage for files recorded in that report."""

import argparse
import os
from pathlib import Path
import re
import sys


def read_coverage(path):
    """Merge line hits across LCOV records without double-counting source files."""
    files = {}
    source = None
    lines = {}
    totals = {}
    for number, text in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not text:
            continue
        if text.startswith("SF:"):
            if source is not None or not text[3:]:
                raise ValueError(f"line {number}: invalid or nested source record")
            source = text[3:]
            lines = {}
            totals = {}
        elif text == "end_of_record":
            if source is None:
                raise ValueError(f"line {number}: record has no source file")
            found = len(lines)
            hit = sum(count > 0 for count in lines.values())
            if totals.get("LF", found) != found or totals.get("LH", hit) != hit:
                raise ValueError(f"line {number}: LF/LH disagree with line data")
            if lines:
                merged = files.setdefault(source, {})
                for line, count in lines.items():
                    merged[line] = merged.get(line, 0) + count
            source = None
        elif text.startswith("DA:"):
            if source is None:
                raise ValueError(f"line {number}: line data has no source record")
            match = re.fullmatch(r"DA:([0-9]+),([0-9]+)(?:,[^,]+)?", text)
            if match is None:
                raise ValueError(f"line {number}: malformed DA line or hit count")
            line, count = int(match[1]), int(match[2])
            if line < 1 or line in lines:
                raise ValueError(f"line {number}: invalid or repeated source line")
            lines[line] = count
        elif text.startswith(("LF:", "LH:")):
            match = re.fullmatch(r"(LF|LH):([0-9]+)", text)
            if source is None or match is None or match[1] in totals:
                raise ValueError(f"line {number}: malformed or repeated line total")
            totals[match[1]] = int(match[2])
        elif not text.startswith(
            ("TN:", "FN:", "FNDA:", "FNF:", "FNH:", "BRDA:", "BRF:", "BRH:", "VER:")
        ):
            raise ValueError(f"line {number}: unrecognized LCOV entry")
    if source is not None:
        raise ValueError("source record is missing end_of_record")
    if not files:
        raise ValueError("report contains no executable line data (DA records)")
    found = sum(len(lines) for lines in files.values())
    hit = sum(count > 0 for lines in files.values() for count in lines.values())
    return len(files), found, hit


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("lcov", type=Path, help="LCOV report to validate")
    args = parser.parse_args()
    try:
        file_count, found, hit = read_coverage(args.lcov)
        message = (
            f"Recorded-file line coverage: {100 * hit / found:.2f}% "
            f"({hit}/{found} lines across {file_count} recorded files).\n"
            "This is not whole-project coverage: files absent from LCOV are excluded.\n"
        )
        summary = os.environ.get("GITHUB_STEP_SUMMARY")
        if summary:
            with Path(summary).open("a", encoding="utf-8") as output:
                output.write("### Test coverage\n\n" + message + "\n")
        print(message, end="")
    except (OSError, UnicodeError, ValueError) as error:
        print(f"Invalid coverage report: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
