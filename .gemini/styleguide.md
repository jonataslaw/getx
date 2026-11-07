# GetX code review guide

Review changes against this branch's public APIs, tests, and Flutter/Dart
constraints. Prioritize actionable regressions, correctness, and security.
Explain the triggering scenario and affected behavior, cite relevant code, and
distinguish evidence from assumptions. Automated suggestions are advisory;
human reviewers decide whether to accept them.

## Architecture and compatibility

Preserve GetX's reactive state, dependency injection, navigation, and HTTP
design. Avoid unrelated rewrites or replacement frameworks. Check exports in
`lib/get.dart` and the affected module, supported SDKs, and callers before
suggesting API changes. Breaking changes need explicit migration guidance.

## Reactive state and lifecycle

In `lib/get_rx/` and `lib/get_state_manager/`, check listener registration,
notifications, worker cancellation, and stream re-subscription. Consider
reentrant updates and lazy iterables. Check `lib/get_instance/src/lifecycle.dart`
for callbacks scheduled after a controller has been disposed.

## Dependency injection

In `lib/get_instance/`, check tagged registrations, bindings, lazy creation,
permanent/fenix behavior, and SmartManagement. Verify dependency creation and
disposal follow their documented ownership and do not leak across tests.

## Navigation and overlays

In `lib/get_navigation/`, check nested navigators, route replacement/removal,
middleware, typed results, and completion of returned futures. Review back
handling, controller disposal, and snackbar/dialog cleanup on every exit path.

## HTTP and platform behavior

In `lib/get_connect/`, check synchronous and asynchronous modifiers,
authentication retries, error propagation, and resource cleanup. Consider both
IO and browser behavior. Avoid exposing credentials or response data through
diagnostics.

## Tests and review scope

Look for focused tests demonstrating observable behavior. Bug fixes should
include a regression test that fails before the fix. Check neighboring callers
and cleanup paths, but avoid unrelated style changes. Never claim tests ran
without execution results. Leave mechanical style checks to the formatter and
analyzer. Follow the project's contribution and AI contribution guides.
