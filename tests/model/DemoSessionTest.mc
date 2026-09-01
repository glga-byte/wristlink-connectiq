import Toybox.Test;

(:test)
function testDemoSessionTransitions(logger) {
    var session = new DemoSession();
    Test.assert(session.hasPending());
    Test.assertEqual(session.selectedNoteIndex(), 0);
    Test.assertEqual(session.navigationOutcome(), DemoSessionState.NAVIGATION_IDLE);
    Test.assertEqual(session.timerOutcome(), DemoSessionState.TIMER_READY);
    Test.assert(!session.savedReceivedNote());

    session.selectNextNote();
    Test.assertEqual(session.selectedNoteIndex(), 1);
    session.selectNextNote();
    Test.assertEqual(session.selectedNoteIndex(), 0);
    session.selectNote(1);
    Test.assertEqual(session.selectedNote().title, "Trail checklist");

    session.startTimer();
    Test.assertEqual(session.timerOutcome(), DemoSessionState.TIMER_STARTED);
    session.saveReceivedNote();
    Test.assert(session.savedReceivedNote());
    Test.assertEqual(session.selectedNoteIndex(), 0);
    session.launchNavigation();
    Test.assert(!session.hasPending());
    Test.assertEqual(session.navigationOutcome(), DemoSessionState.NAVIGATION_LAUNCHED);
    session.deferNavigation();
    Test.assertEqual(session.navigationOutcome(), DemoSessionState.NAVIGATION_IDLE);

    var freshSession = new DemoSession();
    Test.assert(freshSession.hasPending());
    Test.assertEqual(freshSession.timerOutcome(), DemoSessionState.TIMER_READY);
    Test.assert(!freshSession.savedReceivedNote());
    Test.assertEqual(freshSession.noteCount(), 2);
    return true;
}
