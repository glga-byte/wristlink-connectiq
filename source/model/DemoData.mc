import Toybox.Lang;

module DemoData {
    const APP_UUID = "DA257BCA209143DF80CA7090A6A89EC7";
    const APP_NAME = "WristLink";
    const APP_PLATFORM = "Connect IQ";
    const CONTRACT_VERSION = "v1";
    const NAVIGATION_TITLE = "Launch navigation";
    const NAVIGATION_DESTINATION = "Trailhead parking";
    const NAVIGATION_STATUS = "pending";
    const NOTE_TITLE = "Gate code";
    const NOTE_BODY = "Code 1234. Use the side entrance.";
    const NOTE_SAVED_SUMMARY = "Saved today";
    const NOTE_STATUS = "saved";
    const SECOND_NOTE_TITLE = "Trail checklist";
    const SECOND_NOTE_BODY = "Water, headlamp, map, and jacket.";
    const SECOND_NOTE_SAVED_SUMMARY = "Saved yesterday";
    const TIMER_LABEL = "Tea";
    const TIMER_DURATION_SECONDS = 180;
    const TIMER_DURATION_LABEL = "3:00";
    const TIMER_STATUS = "accepted";
    const RECENT_SUMMARY_COUNT = 4;
    const READINESS_STATUS = "Ready";
    const PHONE_LINK_STATUS = "Connected";
    const LAST_ACK_STATUS = "Accepted";

    function recentItems() as Array<DemoItem> {
        return [
            new DemoItem(NAVIGATION_DESTINATION, DemoItemType.TYPE_NAVIGATION, DemoItemType.TYPE_NAVIGATION, NAVIGATION_STATUS),
            new DemoItem(NOTE_TITLE, DemoItemType.TYPE_NOTE, DemoItemType.TYPE_NOTE, NOTE_STATUS),
            new DemoItem(TIMER_LABEL, DemoItemType.TYPE_TIMER, DemoItemType.TYPE_TIMER, TIMER_STATUS)
        ] as Array<DemoItem>;
    }

    function notes() as Array<DemoNote> {
        return [
            new DemoNote(NOTE_TITLE, NOTE_BODY, NOTE_SAVED_SUMMARY),
            new DemoNote(SECOND_NOTE_TITLE, SECOND_NOTE_BODY, SECOND_NOTE_SAVED_SUMMARY)
        ] as Array<DemoNote>;
    }

    function status() as Dictionary<String, String> {
        return {
            "readiness" => READINESS_STATUS,
            "phoneLink" => PHONE_LINK_STATUS,
            "lastAck" => LAST_ACK_STATUS,
            "contract" => CONTRACT_VERSION
        };
    }

    function about() as Dictionary<String, String> {
        return {
            "name" => APP_NAME,
            "platform" => APP_PLATFORM,
            "contract" => CONTRACT_VERSION,
            "uuid" => APP_UUID
        };
    }
}
