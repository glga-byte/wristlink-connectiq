import Toybox.Test;

(:test)
function testDemoDataRecentItemFixtures(logger) {
    var recent = DemoData.recentItems();

    Test.assertEqual(recent.size(), 3);
    Test.assertEqual(DemoData.RECENT_SUMMARY_COUNT, 4);
    Test.assertEqual(recent[0].title, "Trailhead parking");
    Test.assertEqual(recent[0].detail, "Navigate");
    Test.assertEqual(recent[0].type, DemoItemType.TYPE_NAVIGATION);
    Test.assertEqual(recent[0].status, "pending");
    Test.assertEqual(recent[1].title, "Gate code");
    Test.assertEqual(recent[1].detail, "Note");
    Test.assertEqual(recent[1].type, DemoItemType.TYPE_NOTE);
    Test.assertEqual(recent[1].status, "saved");
    Test.assertEqual(recent[2].title, "Tea");
    Test.assertEqual(recent[2].detail, "Timer");
    Test.assertEqual(recent[2].type, DemoItemType.TYPE_TIMER);
    Test.assertEqual(recent[2].status, "accepted");
    return true;
}

(:test)
function testDemoDataNavigationAndTimerFixtures(logger) {
    Test.assertEqual(DemoData.NAVIGATION_TITLE, "Launch navigation");
    Test.assertEqual(DemoData.NAVIGATION_DESTINATION, "Trailhead parking");
    Test.assertEqual(DemoData.NAVIGATION_STATUS, "pending");
    Test.assertEqual(DemoData.TIMER_LABEL, "Tea");
    Test.assertEqual(DemoData.TIMER_DURATION_SECONDS, 180);
    Test.assertEqual(DemoData.TIMER_DURATION_LABEL, "3:00");
    Test.assertEqual(DemoData.TIMER_STATUS, "accepted");
    return true;
}

(:test)
function testDemoDataNoteFixtures(logger) {
    var notes = DemoData.notes();

    Test.assertEqual(notes.size(), 2);
    Test.assertEqual(notes[0].title, "Gate code");
    Test.assertEqual(notes[0].body, "Code 1234. Use the side entrance.");
    Test.assertEqual(notes[0].savedSummary, "Saved today");
    Test.assertEqual(notes[1].title, "Trail checklist");
    Test.assertEqual(notes[1].body, "Water, headlamp, map, and jacket.");
    Test.assertEqual(notes[1].savedSummary, "Saved yesterday");
    return true;
}

(:test)
function testDemoDataStatusFixture(logger) {
    var status = DemoData.status();

    Test.assertEqual(status["readiness"], "Ready");
    Test.assertEqual(status["phoneLink"], "Connected");
    Test.assertEqual(status["lastAck"], "Accepted");
    Test.assertEqual(status["contract"], "v1");
    return true;
}

(:test)
function testDemoDataAboutFixture(logger) {
    var about = DemoData.about();

    Test.assertEqual(about["name"], "WristLink");
    Test.assertEqual(about["platform"], "Connect IQ");
    Test.assertEqual(about["contract"], "v1");
    Test.assertEqual(about["uuid"], "DA257BCA209143DF80CA7090A6A89EC7");
    return true;
}
