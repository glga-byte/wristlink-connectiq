import Toybox.Lang;

module DemoData {
    const APP_UUID = "DA257BCA209143DF80CA7090A6A89EC7";
    const CONTRACT_VERSION = "v1";
    const NAVIGATION_TITLE = "Launch navigation";
    const NAVIGATION_DESTINATION = "Trailhead parking";
    const NOTE_TITLE = "Gate code";
    const NOTE_BODY = "Code 1234. Use the side entrance.";
    const TIMER_LABEL = "Tea";
    const TIMER_DURATION_SECONDS = 180;
    const TIMER_DURATION_LABEL = "3:00";
    const RECENT_SUMMARY_COUNT = 4;

    function recentItems() as Array<DemoItem> {
        return [
            new DemoItem(NAVIGATION_DESTINATION, "Navigate", DemoItemType.TYPE_NAVIGATION, "pending"),
            new DemoItem(NOTE_TITLE, "Note", DemoItemType.TYPE_NOTE, "saved"),
            new DemoItem(TIMER_LABEL, "Timer", DemoItemType.TYPE_TIMER, "accepted")
        ] as Array<DemoItem>;
    }

    function notes() as Array<DemoNote> {
        return [
            new DemoNote(NOTE_TITLE, NOTE_BODY, "Saved today"),
            new DemoNote("Trail checklist", "Water, headlamp, map, and jacket.", "Saved yesterday")
        ] as Array<DemoNote>;
    }

    function status() as Dictionary<String, String> {
        return {
            "readiness" => "Ready",
            "phoneLink" => "Connected",
            "lastAck" => "Accepted",
            "contract" => CONTRACT_VERSION
        };
    }

    function about() as Dictionary<String, String> {
        return {
            "name" => "WristLink",
            "platform" => "Connect IQ",
            "contract" => CONTRACT_VERSION,
            "uuid" => APP_UUID
        };
    }
}
