import Toybox.Application;

class WristLinkApp extends Application.AppBase {
    private var _session;
    private var _navigator;

    public function initialize() {
        AppBase.initialize();
        _session = new DemoSession();
        _navigator = new AppNavigator(_session, null);
    }

    public function getInitialView() {
        return _navigator.initialView();
    }
}
