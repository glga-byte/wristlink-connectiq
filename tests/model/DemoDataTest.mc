import Toybox.Test;

(:test)
function testDemoDataFixtures(logger) {
    var recent = DemoData.recentItems();
    var notes = DemoData.notes();
    var status = DemoData.status();
    var about = DemoData.about();

    Test.assertEqual(recent.size(), 3);
    Test.assertEqual(DemoData.RECENT_SUMMARY_COUNT, 4);
    Test.assertEqual(recent[0].title, "Trailhead parking");
    Test.assertEqual(recent[0].type, DemoItemType.TYPE_NAVIGATION);
    Test.assertEqual(recent[0].status, "pending");
    Test.assertEqual(recent[1].title, "Gate code");
    Test.assertEqual(recent[1].type, DemoItemType.TYPE_NOTE);
    Test.assertEqual(recent[1].status, "saved");
    Test.assertEqual(recent[2].title, "Tea");
    Test.assertEqual(recent[2].type, DemoItemType.TYPE_TIMER);
    Test.assertEqual(recent[2].status, "accepted");
    Test.assertEqual(DemoData.TIMER_DURATION_SECONDS, 180);
    Test.assertEqual(notes.size(), 2);
    Test.assertEqual(notes[0].body, "Code 1234. Use the side entrance.");
    Test.assertEqual(status["readiness"], "Ready");
    Test.assertEqual(status["phoneLink"], "Connected");
    Test.assertEqual(status["lastAck"], "Accepted");
    Test.assertEqual(about["platform"], "Connect IQ");
    Test.assertEqual(about["uuid"], DemoData.APP_UUID);
    return true;
}
