# GetX 5 release scope

This document defines the scope selected for stabilizing the existing GetX 5
RC. It is not an announcement that a stable package has been published. The
working package remains `5.0.0-release-candidate-9.4.0` until the final release
artifact is versioned and published.

The release prioritizes the RC's reactive state, dependency injection,
Navigator 2, overlays and GetConnect contracts. An unresolved upstream issue
does not by itself block this release. Reports outside the reproduced and
documented contracts are follow-up work; they are not all claimed fixed.
New regressions in the selected contracts still require assessment before
publication. Follow-up fixes should receive versions appropriate to their
compatibility impact.

## Selected compatibility

- Flutter 3.47.9 and Dart 3.13.7 are the validated SDK baseline. The manifest's
  lower bounds do not certify every later SDK or platform automatically.
- This tree uses `package:flutter/material.dart` and
  `package:flutter/cupertino.dart`. Standalone `material_ui` / `cupertino_ui`
  types are a separate compatibility decision; they cannot be mixed with
  these constructor types. Moving public UI types is not an ordinary patch fix.
- Android emulator and physical iOS acceptance are scoped to the SDK, host,
  transition and operating-system versions recorded in the
  [native checks](../../example_nav2/test/device/README.md).
- The documented [web encoding and reload limitations](migration_guide_5.md#navigation-uses-navigator-2)
  remain known SDK/host limitations. A green ordinary browser test does not
  claim that strict encoded-query behavior has been fixed.

## Master reconciliation

On 2026-11-05, upstream `master` was checked at
[`a294d2fb`](https://github.com/jonataslaw/getx/commit/a294d2fbfc65856ca1da1bd37e5018e778e8939a).
The shared RC base is `9eb7b68e`. The 35 master-only commits include merges and
tooling changes, rather than 35 independent missing fixes. Changes were
reviewed by behavior, including the non-UI changes inside the standalone UI PR.

| Master change | Decision for this release |
|---|---|
| #3298 route names, #3301 RC merge | The RC base already contains the route-name fix; no second merge is needed. |
| #3291 platform/dependency setup, #3302 CI | The examples and CI use the selected SDK and current Android build setup. Older SDK pins and generated machine files are not imported. |
| #3318 navigation defaults and observers | Already covered by app forwarding, platform defaults, optional observers and typed overlay tests. Existing public helpers are retained. |
| #3335 CupertinoSheet | Already covered by the Cupertino sheet transition regression. |
| #3361 lifecycle and scrolling | Scroll disposal and memory/accessibility callbacks are already implemented and tested. Documentation uses this tree's actual StateMixin API. |
| #3417 snackbar overlay lookup | Already covered, together with queue, timer, swipe and disposal regressions. |
| #3427 pop-mode annotation | Already present with exhaustive PopMode handling. |
| Flutter 3.44 Cupertino import compatibility | Already covered on the selected SDK. |
| #3459 TickerMode | Already covered for both `enabled` and `forceFrames`. |
| #3461 documentation, extension relocation and API cleanup | Retain RC imports, extension paths and compatibility helpers. The separately selected low-level page-removal callback migration is documented below. Use the RC migration guide instead of copying master examples with different contracts. |
| #3472 / `28cb1bba`: mutable default Rx collections | Ported independently of the UI migration. Empty RxList/RxMap/RxSet constructors allocate fresh mutable backing collections; explicit backing collections retain their behavior. |
| #3472 / `28cb1bba`: optional navigation contexts | Ported independently. Get.context and Get.overlayContext return null outside the mounted application's lifetime; mounted access and strict root access retain their contracts. |
| #3472 / `28cb1bba`: Get.back overlay behavior | Preserve this RC's explicit page/overlay closing contract. Typed `closeDialog`, `closeBottomSheet`, `closeOverlay`, snackbar helpers and the migration aid `backLegacy` cover the closing operations. |
| #3472 standalone UI types and dependencies | Deferred. This is a public type migration, not required to run the selected bundled-UI baseline. |
| Constructor shorthand, formatting and helper/alias cleanup | Cosmetic rewrites do not require a runtime backport. Retain compatibility helpers and accepted public APIs instead of matching master's text. |
| Nepali translation and unrelated generated assets | Additional localization and machine-generated files are outside this stabilization scope. |

The newly ported fixes have regressions in
[`rx_collection_defaults_test.dart`](../../test/rx/rx_collection_defaults_test.dart)
and [`rc_optional_context_test.dart`](../../test/regression/rc_optional_context_test.dart).
Each failed against the previous implementation before its fix was applied.
The original fixes came from the already merged
[PR #3472](https://github.com/jonataslaw/getx/pull/3472); no duplicate upstream
fix is being presented.

## Navigator callback modernization

The 2026-11-08 follow-up migrates GetNavigator, its onGenerateRoute constructor,
GetDelegate and GetRouterOutlet.pickPages from Flutter's deprecated onPopPage
path to onDidRemovePage. This deliberately changes the low-level constructor
callback argument; application-facing Get.to/Get.back result types remain.
Vetoes belong to Page.canPop / PopScope. Typed results are forwarded separately
from route completion, and committed removals target the specific history
entry. See the [callback migration](migration_guide_5.md#low-level-page-removal-callbacks)
before updating custom navigator/outlet integrations.

## Follow-up work and publication

Open-issue triage, new features, additional host/SDK combinations, standalone UI
migration and SDK-level encoding changes can be scheduled after this release.
Deferral means those items remain tracked or documented, not that they have
been fixed. Do not advertise unsupported combinations as part of the release.

Before publication, validate the exact final revision, package contents and
consumer migration. The branch's passing tests and historical target checks
must be distinguished from validation of a later revision. Versioning,
merging into the release branch, tagging and package publication are separate
release actions; this document performs none of them.
