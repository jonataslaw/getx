import Foundation
import XCTest
import XCUIAutomation

/// External native UI suite for the dedicated GetX device probe only.
/// APP_BUNDLE_ID must be injected into the TEST RUNNER environment by its host.
/// This source does not configure signing, install profiles, or interact with unrelated applications.
@MainActor
final class DeviceNavigationUITests: XCTestCase {
    private var app: XCUIApplication!
    private let timeout: TimeInterval = 12
    private enum ProbeError: Error { case missingBundleID, invalidBundleID }

    private enum ID {
        static let home = "probe.root.marker"
        static let openSwipe = "probe.open.detail"
        static let swipe = "probe.detail.marker"
        static let finish = "probe.close.result"
        static let result = "probe.result"
        static let openLocked = "probe.open.veto"
        static let locked = "probe.veto.marker"
        static let reset = "probe.reset.root"
        static let policy = "probe.veto.policy"
        static let boot = "probe.boot"
        static let pid = "probe.pid"
        static let count = "probe.count"
        static let increment = "probe.increment"
        static let noteInput = "probe.note.input"
        static let noteValue = "probe.note.value"
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        guard let bundle = ProcessInfo.processInfo.environment["APP_BUNDLE_ID"], !bundle.isEmpty else {
            XCTFail("APP_BUNDLE_ID is required in the test runner environment; no default application is launched")
            throw ProbeError.missingBundleID
        }
        guard bundle.contains("."), !bundle.contains(" "), !bundle.hasPrefix("com.apple.") else {
            XCTFail("APP_BUNDLE_ID must identify the dedicated GetX probe application")
            throw ProbeError.invalidBundleID
        }
        app = XCUIApplication(bundleIdentifier: bundle)
        dismissProbeNetworkPromptIfPresent()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: timeout))
        dismissProbeNetworkPromptIfPresent()
        require(ID.home)
        evidence("launched")
    }

    override func tearDownWithError() throws {
        if let app, app.state == .runningForeground, !name.contains("Background") {
            evidence("final")
            app.terminate()
        }
        app = nil
    }

    @discardableResult
    private func require(_ identifier: String, file: StaticString = #filePath, line: UInt = #line) -> XCUIElement {
        let element = app.descendants(matching: .any).matching(identifier: identifier).firstMatch
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "Missing probe accessibility identifier: \(identifier)", file: file, line: line)
        return element
    }

    private func dismissProbeNetworkPromptIfPresent() {
        guard let name = ProcessInfo.processInfo.environment["APP_DISPLAY_NAME"], !name.isEmpty else { return }
        // Scope system-UI access to this dedicated application's own prompt.
        let alert = XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch
        guard alert.exists else { return }
        let message = alert.label + " " + alert.staticTexts.allElementsBoundByIndex.map(\.label).joined(separator: " ")
        guard message.contains(name), message.localizedCaseInsensitiveContains("local network") else { return }
        let deny = alert.buttons.matching(NSPredicate(format: "label IN %@", ["Don't Allow", "Don’t Allow"])).firstMatch
        if deny.exists { deny.tap() }
    }

    private func tap(_ identifier: String) {
        dismissProbeNetworkPromptIfPresent()
        let element = require(identifier)
        XCTAssertTrue(app.state == .runningForeground)
        XCTAssertTrue(element.isHittable, "Probe control is not hittable: \(identifier)")
        // Native injected touch at the center of the identified accessibility element.
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    private func expectLabel(_ identifier: String, _ label: String) {
        let element = require(identifier)
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label == %@", label), object: element)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), .completed, "Expected \(identifier) label \(label), observed \(element.label)")
    }

    private func edgeDrag(completing: Bool) {
        XCTAssertTrue(app.state == .runningForeground)
        let window = app.windows.firstMatch
        XCTAssertTrue(window.exists && window.frame.width > 100 && window.frame.height > 100)
        // Never use absolute screen coordinates or system/Home-button actions.
        let start = window.coordinate(withNormalizedOffset: CGVector(dx: 0.01, dy: 0.5))
        let end = window.coordinate(withNormalizedOffset: CGVector(dx: completing ? 0.90 : 0.18, dy: 0.5))
        // Slow short drag + hold removes fling momentum; release below halfway cancels.
        start.press(forDuration: 0.08, thenDragTo: end,
                    withVelocity: completing ? 350 : 100,
                    thenHoldForDuration: completing ? 0.2 : 0.7)
    }

    private func mustRemainOn(_ identifier: String) {
        let home = app.descendants(matching: .any).matching(identifier: ID.home).firstMatch
        let noHome = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: home)
        noHome.isInverted = true
        XCTAssertEqual(XCTWaiter.wait(for: [noHome], timeout: 1.5), .completed, "Route unexpectedly popped after gesture")
        require(identifier)
    }

    private func evidence(_ name: String) {
        guard app.state == .runningForeground else { return }
        XCTContext.runActivity(named: name) { activity in
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = name
            screenshot.lifetime = .keepAlways
            activity.add(screenshot)
            let tree = XCTAttachment(string: app.debugDescription)
            tree.name = "\(name)-accessibility-tree"
            tree.lifetime = .keepAlways
            activity.add(tree)
        }
    }

    func testNativeTapReturnsTypedResult() {
        tap(ID.openSwipe)
        require(ID.swipe)
        tap(ID.finish)
        require(ID.home)
        expectLabel(ID.result, "RESULT:42")
        evidence("typed-result")
    }

    func testCancelledNativeEdgeDragKeepsRouteAndResultPending() {
        tap(ID.openSwipe)
        require(ID.swipe)
        edgeDrag(completing: false)
        mustRemainOn(ID.swipe)
        evidence("cancelled-edge-drag")
        tap(ID.finish)
        require(ID.home)
        expectLabel(ID.result, "RESULT:42")
    }

    func testCompletedNativeEdgeDragPopsWithNullResult() {
        tap(ID.openSwipe)
        require(ID.swipe)
        edgeDrag(completing: true)
        require(ID.home)
        expectLabel(ID.result, "RESULT:null")
        evidence("completed-edge-drag")
    }

    func testCanPopFalseBlocksNativeEdgeDragThenResetRestoresRoot() {
        tap(ID.openLocked)
        require(ID.locked)
        expectLabel(ID.policy, "CAN_POP:false")
        edgeDrag(completing: true)
        mustRemainOn(ID.locked)
        evidence("can-pop-false")
        // Dedicated reset replaces the stack; this is cleanup, not a canPop bypass.
        tap(ID.reset)
        require(ID.home)
    }
    private func assertRestoredHistoryReturnsToRoot() {
        // The old Dart Future cannot survive native process death. Check restored
        // navigation history only; do not expect RESULT:42 from a dead awaiter.
        tap(ID.finish)
        require(ID.home)
        let detail = app.descendants(matching: .any).matching(identifier: ID.swipe).firstMatch
        let absent = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: detail)
        XCTAssertEqual(XCTWaiter.wait(for: [absent], timeout: timeout), .completed,
                       "Restored detail remained visible after returning to root")
        let noPhantom = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: detail)
        noPhantom.isInverted = true
        XCTAssertEqual(XCTWaiter.wait(for: [noPhantom], timeout: 1.5), .completed,
                       "Phantom detail reappeared after restored back navigation")
        require(ID.home)
        evidence("restored-history-returned-root")
    }

    /// Run alone; the external driver kills only the prepared probe PID.
    func testBackgroundProcessDeathRestoresHistory() {
        tap(ID.openSwipe)
        require(ID.swipe)
        expectLabel(ID.count, "COUNT:0")
        for _ in 0..<7 { tap(ID.increment) }
        expectLabel(ID.count, "COUNT:7")
        let note = require(ID.noteInput)
        tap(ID.noteInput)
        note.typeText("restored-note")
        expectLabel(ID.noteValue, "NOTE:restored-note")
        let previousBoot = require(ID.boot).label
        let previousPID = require(ID.pid).label
        XCTAssertTrue(previousBoot.hasPrefix("BOOT:"))
        XCTAssertTrue(previousPID.hasPrefix("PID:"))
        let metadata = "PREVIOUS_BOOT=\(previousBoot)\nPREVIOUS_PID=\(previousPID)"
        let attachment = XCTAttachment(string: metadata)
        attachment.name = "single-session-prepared-process-identifiers"
        attachment.lifetime = .keepAlways
        add(attachment)
        evidence("single-session-restoration-prepared")
        XCUIDevice.shared.press(.home)
        let background = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "state == %d OR state == %d",
                                   XCUIApplication.State.runningBackground.rawValue,
                                   XCUIApplication.State.runningBackgroundSuspended.rawValue), object: app)
        XCTAssertEqual(XCTWaiter.wait(for: [background], timeout: timeout), .completed)
        Thread.sleep(forTimeInterval: 4)
        // Direct FileHandle write is unbuffered by Swift's print/stdout buffer.
        FileHandle.standardOutput.write(Data((metadata + "\nPROCESS_DEATH_READY\n").utf8))
        let died = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "state == %d", XCUIApplication.State.notRunning.rawValue), object: app)
        XCTAssertEqual(XCTWaiter.wait(for: [died], timeout: 60), .completed,
                       "Root did not terminate the identified background probe within 60 seconds")
        // activate() deliberately avoids launch() and any app reinstall/reset.
        app.activate()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: timeout))
        require(ID.swipe)
        let currentBoot = require(ID.boot).label
        let currentPID = require(ID.pid).label
        XCTAssertTrue(currentBoot.hasPrefix("BOOT:"))
        XCTAssertTrue(currentPID.hasPrefix("PID:"))
        XCTAssertNotEqual(currentBoot, previousBoot, "Process boot identity did not change")
        XCTAssertNotEqual(currentPID, previousPID, "Native PID did not change")
        expectLabel(ID.count, "COUNT:7")
        expectLabel(ID.noteValue, "NOTE:restored-note")
        evidence("single-session-restoration-restored")
        tap(ID.increment)
        expectLabel(ID.count, "COUNT:8")
        evidence("single-session-restoration-live")
        let restored = "RESTORED_BOOT=\(currentBoot)\nRESTORED_PID=\(currentPID)"
        FileHandle.standardOutput.write(Data((restored + "\n").utf8))
        let restoredAttachment = XCTAttachment(string: restored)
        restoredAttachment.name = "single-session-restored-process-identifiers"
        restoredAttachment.lifetime = .keepAlways
        add(restoredAttachment)
        assertRestoredHistoryReturnsToRoot()
        // Leave final cleanup to root, even on failure.
    }

}
