import Toybox.Lang;
import Toybox.Test;

(:test)
function testDemoSessionStartsWithOriginalFixtures(logger) {
    var session = new DemoSession();

    Test.assert(session.hasPending());
    Test.assertEqual(session.inboxState(), DemoSessionState.INBOX_PENDING);
    Test.assertEqual(session.recentItems().size(), 3);
    Test.assertEqual(session.recentSummaryCount(), 4);
    Test.assertEqual(session.noteCount(), 2);
    Test.assertEqual(session.selectedNoteIndex(), 0);
    Test.assertEqual(session.selectedNote().title, DemoData.NOTE_TITLE);
    Test.assertEqual(session.navigationOutcome(), DemoSessionState.NAVIGATION_IDLE);
    Test.assertEqual(session.timerOutcome(), DemoSessionState.TIMER_READY);
    Test.assert(!session.savedReceivedNote());
    return true;
}

(:test)
function testDemoSessionCyclesAndSelectsNotes(logger) {
    var session = new DemoSession();

    session.selectNextNote();
    Test.assertEqual(session.selectedNoteIndex(), 1);
    Test.assertEqual(session.selectedNote().title, DemoData.SECOND_NOTE_TITLE);
    session.selectNextNote();
    Test.assertEqual(session.selectedNoteIndex(), 0);
    session.selectNote(1);
    Test.assertEqual(session.selectedNoteIndex(), 1);
    session.selectNote(-1);
    Test.assertEqual(session.selectedNoteIndex(), 1);
    session.selectNote(2);
    Test.assertEqual(session.selectedNoteIndex(), 1);
    return true;
}

(:test)
function testDemoSessionLaunchConsumesPendingNavigation(logger) {
    var session = new DemoSession();

    session.launchNavigation();
    Test.assert(!session.hasPending());
    Test.assertEqual(session.inboxState(), DemoSessionState.INBOX_EMPTY);
    Test.assertEqual(session.navigationOutcome(), DemoSessionState.NAVIGATION_LAUNCHED);
    return true;
}

(:test)
function testDemoSessionLaterPreservesPendingNavigation(logger) {
    var session = new DemoSession();

    session.deferNavigation();
    Test.assert(session.hasPending());
    Test.assertEqual(session.inboxState(), DemoSessionState.INBOX_PENDING);
    Test.assertEqual(session.navigationOutcome(), DemoSessionState.NAVIGATION_DEFERRED);
    return true;
}

(:test)
function testDemoSessionStartsTimerInMemory(logger) {
    var session = new DemoSession();

    session.startTimer();
    Test.assertEqual(session.timerOutcome(), DemoSessionState.TIMER_STARTED);
    return true;
}

(:test)
function testDemoSessionSavesReceivedNoteForSession(logger) {
    var session = new DemoSession();

    session.selectNote(1);
    session.saveReceivedNote();
    Test.assert(session.savedReceivedNote());
    Test.assertEqual(session.selectedNoteIndex(), 0);
    Test.assertEqual(session.selectedNote().title, DemoData.NOTE_TITLE);
    Test.assertEqual(session.selectedNote().body, DemoData.NOTE_BODY);
    return true;
}

(:test)
function testFreshDemoSessionRestoresOriginalFixtures(logger) {
    var changedSession = new DemoSession();

    changedSession.selectNextNote();
    changedSession.launchNavigation();
    changedSession.startTimer();
    changedSession.saveReceivedNote();

    var freshSession = new DemoSession();
    Test.assert(freshSession.hasPending());
    Test.assertEqual(freshSession.inboxState(), DemoSessionState.INBOX_PENDING);
    Test.assertEqual(freshSession.navigationOutcome(), DemoSessionState.NAVIGATION_IDLE);
    Test.assertEqual(freshSession.timerOutcome(), DemoSessionState.TIMER_READY);
    Test.assert(!freshSession.savedReceivedNote());
    Test.assertEqual(freshSession.selectedNoteIndex(), 0);
    Test.assertEqual(freshSession.noteCount(), 2);
    var freshRecent = freshSession.recentItems() as Array<DemoItem>;
    Test.assertEqual(freshRecent[0].title, DemoData.NAVIGATION_DESTINATION);
    Test.assertEqual(freshSession.selectedNote().title, DemoData.NOTE_TITLE);
    return true;
}
