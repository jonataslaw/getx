# Activating PR quality checks

The repository files provide contributor guidance, CI jobs, review configuration,
and an importable ruleset. They do not install a review service or apply GitHub
repository settings. An administrator must complete those steps on the intended
repository. Configuration on a fork does not configure `jonataslaw/getx`.

## CI and coverage

The `build` workflow targets `master` pushes and PRs, with a manual run option.
It preserves the existing analysis policy: errors and info diagnostics are fatal,
while warnings remain visible but non-fatal.

Jobs check workflow security and helper scripts, changed-file formatting, static
analysis, root tests on Flutter 3.47.8 and 3.47.9, scoped Rx/DI tests in Chrome,
and LCOV validity. `Required checks` succeeds only when every required job
succeeds; failed, cancelled, or skipped dependencies fail the aggregate.

The coverage artifact and summary are required. External Codecov upload is
informational: enable public tokenless uploads in Codecov before relying on PR
coverage feedback. No repository secret is passed to PR jobs. Do not make
Codecov statuses required until their behavior on fork PRs has been verified.
See [Codecov authentication](https://docs.codecov.com/docs/codecov-tokens).

Formatting covers changed Dart files because the legacy tree is not uniformly
formatted. Analysis retains the existing non-fatal warning policy. These gates
do not impose a new whole-project coverage percentage or validate every example,
browser behavior, native platform, or Flutter version. Validate each release
branch's SDK constraints before extending the workflow beyond `master`.

Third-party actions are pinned to commit SHAs. Dependabot checks GitHub Actions
weekly and proposes grouped updates with a seven-day cooldown; review and test
those changes before merging.

## Merge rules

1. Merge the workflow and observe a successful run on a PR targeting `master`.
2. Inspect existing branch protections and rulesets. Import
   [pr-quality.json](../rulesets/pr-quality.json) in Settings > Rules > Rulesets
   using Import a ruleset, or use the GitHub rulesets REST API. The file starts
   **disabled** so importing it does not immediately block merges.
3. Confirm the target is `master` and the required status is exactly
   `Required checks`, produced by GitHub Actions (integration ID `15368`).
   The proposed rules also require one approving review, dismiss stale approvals,
   require resolved review conversations, and prohibit force pushes/deletion.
4. Review how existing rules and any administrator bypass policy interact with
   this ruleset, then set enforcement to **Active**. The supplied ruleset grants
   no bypass actors. Do not leave an old, removed job such as `test` required.
5. Verify with a test PR that a failing gate and a missing approval prevent
   merging, while a fully passing and approved PR is eligible. Check enforcement
   as a regular contributor as well as an administrator.

Required checks need an up-to-date branch. No merge queue is configured; adding
one later also requires handling `merge_group` workflow events.

See [GitHub rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets)
and the [rulesets API](https://docs.github.com/en/rest/repos/rules#create-a-repository-ruleset).

## Gemini review

The `.gemini/config.yaml` and `.gemini/styleguide.md` files configure review
behavior and GetX-specific priorities. They do not activate the bot.

The consumer GitHub app was retired on July 17, 2026. Current setup uses Gemini
Code Assist on GitHub through Google Cloud. An authorized administrator needs a
Cloud project, valid billing account, required IAM roles, repository app access,
and a Developer Connect connection created through Gemini Agents & Tools in
`us-east1`. Review current service terms and costs before connecting the project.
Follow the [official setup instructions](https://docs.cloud.google.com/gemini/docs/code-review/set-up-code-assist-github)
and [consumer deprecation notice](https://developers.google.com/gemini-code-assist/docs/deprecations/consumer-code-review).

After connection, open a non-draft test PR and verify that the summary and review
appear. Use `/gemini review` in the PR conversation to request a review manually,
including after making a draft ready for review. The configuration disables
draft-open reviews, limits feedback to ten comments of medium or higher severity,
and excludes generated artifacts. The bot does not review `.github/workflows`;
workflow security checks and human review remain necessary.

Bot feedback is advisory, not an approval requirement. Confirm that the guide is
being applied and that the service is connected to the upstream repository, not
only a contributor's fork. See the official
[configuration](https://docs.cloud.google.com/gemini/docs/code-review/customize-repo-review)
and [usage](https://docs.cloud.google.com/gemini/docs/code-review/use-code-assist-github) guides.
