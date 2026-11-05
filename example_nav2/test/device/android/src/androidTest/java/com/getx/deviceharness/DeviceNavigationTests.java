package com.getx.deviceharness;

import static org.junit.Assert.*;

import android.app.Instrumentation;
import android.graphics.Point;
import android.os.Bundle;
import android.os.SystemClock;
import android.view.InputDevice;
import android.view.MotionEvent;

import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.uiautomator.By;
import androidx.test.uiautomator.Direction;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject2;
import androidx.test.uiautomator.Until;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestWatcher;
import org.junit.runner.Description;
import org.junit.runner.RunWith;

import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** Native Android acceptance suite. The runner never lives in the probe process. */
@RunWith(AndroidJUnit4.class)
public class DeviceNavigationTests {
    private static final long TIMEOUT = 15000;
    private Instrumentation instrumentation;
    private UiDevice device;
    private String probePackage;
    private String probeActivity;
    private String displayName;
    private String fingerprint;
    private String androidUser;

    @Rule public final TestWatcher failureEvidence = new TestWatcher() {
        @Override protected void failed(Throwable failure, Description description) {
            if (device != null) {
                try { evidence("FAILED-" + description.getMethodName()); }
                // Diagnostic failures must preserve the original test failure,
                // including when the diagnostic assertion itself throws an Error.
                catch (Throwable evidenceFailure) { failure.addSuppressed(evidenceFailure); }
            }
        }
    };

    private String argument(Bundle arguments, String key) {
        String value = arguments.getString(key);
        assertNotNull("Missing instrumentation argument " + key, value);
        assertFalse("Empty instrumentation argument " + key, value.trim().isEmpty());
        return value;
    }

    @Before
    public void prepareFreshTask() throws Exception {
        instrumentation = InstrumentationRegistry.getInstrumentation();
        device = UiDevice.getInstance(instrumentation);
        Bundle args = InstrumentationRegistry.getArguments();
        probePackage = argument(args, "probePackage");
        probeActivity = argument(args, "probeActivity");
        displayName = argument(args, "displayName");
        fingerprint = argument(args, "buildFingerprint");
        assertTrue("Only a dedicated probe package may be controlled",
                probePackage.matches("[a-zA-Z][a-zA-Z0-9_]*(\\.[a-zA-Z][a-zA-Z0-9_]*)+"));
        assertFalse(probePackage.startsWith("com.android."));
        assertFalse(probePackage.startsWith("com.getx.deviceharness"));
        assertTrue(probeActivity.matches("[a-zA-Z0-9_.$]+"));
        assertNotEquals("UNSET", fingerprint);
        androidUser = shell("am get-current-user");
        assertTrue("Invalid current Android user: " + androidUser, androidUser.matches("[0-9]+"));
        device.wakeUp();
        // force-stop is setup only. The restoration test itself exclusively uses am kill.
        shell("am force-stop --user " + androidUser + " " + probePackage);
        shell("am start --user " + androidUser + " -W -n " + probePackage + "/" + probeActivity);
        label("ROOT_ROUTE");
        deployedArtifact();
        evidence("fresh-root");
    }

    private String shell(String command) throws Exception {
        return device.executeShellCommand(command).trim();
    }

    private UiObject2 label(String value) {
        UiObject2 object = device.wait(Until.findObject(By.desc(value)), TIMEOUT);
        if (object == null) object = device.findObject(By.text(value));
        // Probe status rows and buttons may exceed the emulator's viewport.
        // Only scroll this probe's own accessible list, never system/Recents UI.
        for (Direction direction : new Direction[] {Direction.DOWN, Direction.UP}) {
            for (int i = 0; object == null && i < 4; i++) {
                UiObject2 list = device.findObject(By.pkg(probePackage).scrollable(true));
                if (list == null) break;
                boolean more = list.scroll(direction, 0.65f);
                object = device.findObject(By.desc(value));
                if (object == null) object = device.findObject(By.text(value));
                if (!more) break;
            }
        }
        assertNotNull("Missing label: " + value, object);
        return object;
    }

    private String status(String prefix) {
        UiObject2 object = device.wait(Until.findObject(By.descStartsWith(prefix)), TIMEOUT);
        if (object == null) object = device.wait(Until.findObject(By.textStartsWith(prefix)), 1000);
        assertNotNull("Missing status " + prefix, object);
        String description = object.getContentDescription();
        return description != null && description.startsWith(prefix) ? description : object.getText();
    }

    private void tap(String text) {
        label(text).click();
        device.waitForIdle();
    }

    private void deployedArtifact() {
        label("BUILD:" + fingerprint);
        label("SNAPSHOT_PRESENT:true");
    }

    private int value(String text, String key) {
        Matcher match = Pattern.compile("(?:^|[:,])" + key + "=(\\d+)(?:,|$)").matcher(text);
        assertTrue("Missing " + key + " in " + text, match.find());
        return Integer.parseInt(match.group(1));
    }

    private void lifetime(int created, int closed, int active) {
        label("LIFETIME:created=" + created + ",closed=" + closed + ",active=" + active);
    }

    private void openDetail() {
        tap("OPEN_DETAIL");
        label("DETAIL_ROUTE");
        label("CAN_POP:true");
        deployedArtifact();
    }

    private void remains(String marker) throws Exception {
        long until = SystemClock.uptimeMillis() + 1500;
        while (SystemClock.uptimeMillis() < until) {
            assertNull("Unexpected root after blocked/cancelled gesture", device.findObject(By.desc("ROOT_ROUTE")));
            SystemClock.sleep(100);
        }
        label(marker);
    }

    private void pointer(long down, int action, float x, float y) {
        MotionEvent event = MotionEvent.obtain(down, SystemClock.uptimeMillis(), action, x, y, 0);
        event.setSource(InputDevice.SOURCE_TOUCHSCREEN);
        assertTrue("Native input injection failed", instrumentation.getUiAutomation().injectInputEvent(event, true));
        event.recycle();
    }

    /** A real edge input stream; reversal cancels at the system gesture boundary. */
    private void edgeGesture(boolean commit) {
        int width = device.getDisplayWidth();
        float y = device.getDisplayHeight() * 0.48f;
        long down = SystemClock.uptimeMillis();
        pointer(down, MotionEvent.ACTION_DOWN, 1, y);
        SystemClock.sleep(80);
        float far = width * (commit ? 0.88f : 0.36f);
        for (int i = 1; i <= 24; i++) {
            pointer(down, MotionEvent.ACTION_MOVE, 1 + (far - 1) * i / 24, y);
            SystemClock.sleep(20);
        }
        SystemClock.sleep(250);
        if (!commit) {
            for (int i = 1; i <= 24; i++) {
                pointer(down, MotionEvent.ACTION_MOVE, far - (far - 1) * i / 24, y);
                SystemClock.sleep(20);
            }
            SystemClock.sleep(300);
        }
        pointer(down, MotionEvent.ACTION_UP, commit ? far : 1, y);
        device.waitForIdle();
    }

    private void requirePredictiveEnvironment() throws Exception {
        assertTrue("Predictive callbacks require Android API 34+",
                Integer.parseInt(shell("getprop ro.build.version.sdk")) >= 34);
        assertEquals("Enable gesture navigation on the dedicated emulator before running",
                "2", shell("settings get secure navigation_mode"));
    }

    private void gestureCallbacksAdvanced(String before) {
        String current = status("GESTURES:");
        assertTrue("No native predictive start reached Flutter: " + current,
                value(current, "started") > value(before, "started"));
        assertTrue("No native predictive stop reached Flutter: " + current,
                value(current, "stopped") > value(before, "stopped"));
        assertTrue("No native predictive progress reached Flutter: " + current,
                value(current, "progressed") > value(before, "progressed"));
    }

    @Test public void nativeTypedResultDisposesController() throws Exception {
        lifetime(0, 0, 0);
        openDetail();
        lifetime(1, 0, 1);
        tap("CLOSE_WITH_42");
        label("ROOT_ROUTE");
        label("RESULT:42");
        lifetime(1, 1, 0);
        evidence("typed-result-disposed");
    }

    @Test public void systemBackDisposesAndReturnsNull() throws Exception {
        openDetail();
        lifetime(1, 0, 1);
        device.pressBack();
        label("ROOT_ROUTE");
        label("RESULT:null");
        lifetime(1, 1, 0);
        evidence("system-back");
    }

    @Test public void cancelledPredictiveGestureKeepsControllerAndPendingResult() throws Exception {
        requirePredictiveEnvironment();
        openDetail();
        String before = status("GESTURES:");
        edgeGesture(false);
        remains("DETAIL_ROUTE");
        gestureCallbacksAdvanced(before);
        lifetime(1, 0, 1);
        evidence("predictive-cancelled");
        tap("CLOSE_WITH_42");
        label("ROOT_ROUTE");
        label("RESULT:42");
        lifetime(1, 1, 0);
    }

    @Test public void completedPredictiveGestureDisposesAndReturnsNull() throws Exception {
        requirePredictiveEnvironment();
        openDetail();
        String before = status("GESTURES:");
        edgeGesture(true);
        label("ROOT_ROUTE");
        label("RESULT:null");
        gestureCallbacksAdvanced(before);
        lifetime(1, 1, 0);
        evidence("predictive-completed");
    }

    @Test public void canPopFalseVetoesSystemAndPredictiveBack() throws Exception {
        requirePredictiveEnvironment();
        tap("OPEN_VETO");
        label("VETO_ROUTE");
        label("CAN_POP:false");
        lifetime(1, 0, 1);
        device.pressBack();
        remains("VETO_ROUTE");
        edgeGesture(true);
        remains("VETO_ROUTE");
        lifetime(1, 0, 1);
        evidence("can-pop-false");
        tap("RESET_TO_ROOT");
        label("ROOT_ROUTE");
        lifetime(1, 1, 0);
    }

    @Test public void canPopFalseVetoesSystemBack() throws Exception {
        tap("OPEN_VETO");
        label("VETO_ROUTE");
        label("CAN_POP:false");
        lifetime(1, 0, 1);
        device.pressBack();
        remains("VETO_ROUTE");
        lifetime(1, 0, 1);
        evidence("can-pop-false-system");
        tap("RESET_TO_ROOT");
        label("ROOT_ROUTE");
        lifetime(1, 1, 0);
    }

    @Test public void rootSystemBackExitsActivity() throws Exception {
        label("ROOT_ROUTE");
        lifetime(0, 0, 0);
        device.pressBack();
        assertTrue("System back at root did not dismiss the probe activity",
                device.wait(Until.gone(By.pkg(probePackage)), TIMEOUT));
        assertNotEquals(probePackage, device.getCurrentPackageName());
        // Android may retain the process after Activity exit; no PID-death assertion.
        evidence("root-system-back-exited");
    }

    @Test public void popScopeVetoesSystemBackThenAllowsIt() throws Exception {
        tap("OPEN_SCOPE_VETO");
        label("SCOPE_VETO_ROUTE");
        label("CAN_POP:false");
        lifetime(1, 0, 1);
        device.pressBack();
        remains("SCOPE_VETO_ROUTE");
        lifetime(1, 0, 1);
        evidence("pop-scope-system-veto");
        tap("ALLOW_SCOPE_BACK");
        label("CAN_POP:true");
        device.pressBack();
        label("ROOT_ROUTE");
        label("RESULT:null");
        lifetime(1, 1, 0);
        evidence("pop-scope-system-allowed");
    }

    @Test public void popScopeVetoesGestureThenAllowsPredictiveCommit() throws Exception {
        requirePredictiveEnvironment();
        tap("OPEN_SCOPE_VETO");
        label("SCOPE_VETO_ROUTE");
        label("CAN_POP:false");
        lifetime(1, 0, 1);
        edgeGesture(true);
        remains("SCOPE_VETO_ROUTE");
        lifetime(1, 0, 1);
        evidence("pop-scope-predictive-veto");
        tap("ALLOW_SCOPE_BACK");
        label("CAN_POP:true");
        String before = status("GESTURES:");
        edgeGesture(true);
        label("ROOT_ROUTE");
        label("RESULT:null");
        gestureCallbacksAdvanced(before);
        lifetime(1, 1, 0);
        evidence("pop-scope-predictive-allowed");
    }

    private String taskId() throws Exception {
        String activities = shell("dumpsys activity activities");
        Matcher task = Pattern.compile("(?:mResumedActivity|topResumedActivity)[^\\n]*"
                + Pattern.quote(probePackage) + "/[^\\n]* t(\\d+)").matcher(activities);
        assertTrue("Cannot identify foreground probe task\n" + activities, task.find());
        return task.group(1);
    }

    @Test public void coldProcessRestoresSameTaskHistoryAndPageState() throws Exception {
        openDetail();
        for (int i = 0; i < 7; i++) tap("COUNTER_PLUS");
        label("COUNT:7");
        UiObject2 note = device.findObject(By.res("probe.note.input"));
        if (note == null) note = device.wait(Until.findObject(By.clazz("android.widget.EditText")), TIMEOUT);
        assertNotNull("Note input missing", note);
        note.click();
        note.setText("restored-note");
        // Hide IME, whose back handling is independent of route back.
        device.pressBack();
        label("DETAIL_ROUTE");
        label("NOTE:restored-note");
        String boot = status("BOOT:");
        String pid = status("PID:").substring(4);
        assertTrue(pid.matches("[0-9]+"));
        assertEquals(pid, shell("pidof " + probePackage));
        String task = taskId();
        evidence("restoration-prepared");
        device.pressHome();
        SystemClock.sleep(4000);
        // Retain the stopped Activity/task saved state. Never force-stop or clear data here.
        String killOutput = shell("am kill --user " + androidUser + " " + probePackage);
        System.out.println("GETX_KILL_OUTPUT " + killOutput);
        long deadline = SystemClock.uptimeMillis() + TIMEOUT;
        while (!shell("pidof " + probePackage).isEmpty() && SystemClock.uptimeMillis() < deadline) {
            SystemClock.sleep(100);
        }
        String remainingPID = shell("pidof " + probePackage);
        if (!remainingPID.isEmpty()) {
            String[] processes = shell("dumpsys activity processes").split("\\n");
            for (int i = 0; i < processes.length; i++) {
                if (processes[i].contains(probePackage)) {
                    for (int j = Math.max(0, i - 2); j < Math.min(processes.length, i + 8); j++) {
                        System.out.println("GETX_KILL_DIAGNOSTIC " + processes[j]);
                    }
                }
            }
        }
        assertEquals("Probe process did not die; kill output: " + killOutput,
                "", remainingPID);
        device.pressRecentApps();
        SystemClock.sleep(1200);
        UiObject2 card = device.findObject(By.descContains(displayName));
        if (card == null) card = device.findObject(By.text(displayName));
        assertNotNull("Probe task is not visible in Recents; no launcher fallback is allowed", card);
        // Recents app-icon descendants can open a menu; tap the task thumbnail below its title.
        Point center = card.getVisibleCenter();
        device.click(center.x, Math.min(center.y + device.getDisplayHeight() / 5, device.getDisplayHeight() * 3 / 4));
        label("DETAIL_ROUTE");
        deployedArtifact();
        assertEquals("Recents did not restore the same task", task, taskId());
        assertNotEquals(boot, status("BOOT:"));
        String restoredPid = status("PID:").substring(4);
        assertNotEquals(pid, restoredPid);
        assertEquals(restoredPid, shell("pidof " + probePackage));
        label("COUNT:7");
        label("NOTE:restored-note");
        // Metrics are per process: only the restored detail creates a controller.
        lifetime(1, 0, 1);
        tap("COUNTER_PLUS");
        label("COUNT:8");
        evidence("restoration-recovered");
        tap("CLOSE_WITH_42");
        label("ROOT_ROUTE");
        lifetime(1, 1, 0);
        // The dead Dart Future does not survive. Verify a newly created awaiter instead.
        openDetail();
        lifetime(2, 1, 1);
        tap("CLOSE_WITH_42");
        label("ROOT_ROUTE");
        label("RESULT:42");
        lifetime(2, 2, 0);
        evidence("restoration-history-and-new-result");
        System.out.println("GETX_RESTORATION oldPID=" + pid + " newPID=" + restoredPid + " task=" + task);
    }

    private void evidence(String name) throws Exception {
        // Instrumentation executes under the host UID, not the test APK UID.
        File hostFiles = instrumentation.getTargetContext().getExternalFilesDir(null);
        assertNotNull("External files directory unavailable for instrumentation host", hostFiles);
        File directory = new File(hostFiles, "getx-evidence");
        assertTrue("Cannot create host-owned evidence directory: " + directory,
                directory.isDirectory() || directory.mkdirs());
        File screenshot = new File(directory, name + ".png");
        assertTrue("Cannot capture evidence screenshot: " + screenshot,
                device.takeScreenshot(screenshot));
        device.dumpWindowHierarchy(new File(directory, name + ".xml"));
        System.out.println("GETX_EVIDENCE " + name + " " + directory.getAbsolutePath());
    }
}
