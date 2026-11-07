# AI-assisted contributions

AI assistance is welcome in GetX. The contributor remains responsible for every
submitted change and statement, regardless of which tools helped produce it.

## Before submitting or requesting another review

- Personally review all proposed code, tests, and documentation. Understand the
  changes well enough to explain their behavior and discuss alternatives.
- Verify generated claims. Run the relevant checks and report actual commands,
  SDK versions, results, and limitations. A suggested test is not a test result.
- For a bug fix, confirm the reported failure and that the regression test
  exercises it. Pay attention to notifications, asynchronous completion, and
  cleanup when changing reactive state, controllers, dependencies, or routes.
- Verify that requested changes are present before telling a reviewer that
  their feedback has been addressed. Review and edit generated replies yourself.
- Keep the diff and description focused. Exclude unrelated generated reports,
  assistant transcripts, personal tool configuration, credentials, and planning
  files that do not belong in the project.

For example, if a tool says that removing a route disposes its controller,
inspect the relevant path and test the controller's lifetime before repeating
that claim. If tests were not run, say so and explain why.

Follow the [contribution guide](CONTRIBUTING.md) and the same project standards
as any other contribution. Do not post unattended AI-generated issue comments
or review replies; discuss proposed automated participation with maintainers
first.

## Checklist acknowledgement

When AI tools were used, the PR checklist acknowledgement must be confirmed by
the contributor after their own review. An assistant reading this guide cannot
make that personal acknowledgement on the contributor's behalf. Contributors
who did not use AI tools can confirm the alternative in the same checklist item.

## Automated reviews

Bot feedback is advisory and can be wrong. Evaluate suggestions against the
code and tests; explain disagreements when useful. Human reviewers determine
whether a contribution is ready to merge. This guide does not introduce a CLA
or change GetX's license.
