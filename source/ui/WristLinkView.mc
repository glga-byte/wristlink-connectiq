import Toybox.Graphics;
import Toybox.WatchUi;

class WristLinkView extends WatchUi.View {
    protected var _session;
    protected var _navigator;
    protected var _width;
    protected var _height;
    private var _background;

    public function initialize(session, navigator) {
        View.initialize();
        _session = session;
        _navigator = navigator;
        _width = 0;
        _height = 0;
        _background = UiTheme.LIGHT_BACKGROUND;
    }

    public function isDark() {
        return false;
    }

    public function onLayout(dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        rebuild();
    }

    public function onShow() {
        if (_width > 0) {
            rebuild();
        }
    }

    protected function buildLayout(metrics) {
        return [];
    }

    public function rebuild() {
        var metrics = new UiMetrics(_width, _height);
        _background = UiTheme.background(isDark());
        setLayout(buildLayout(metrics));
        setKeyToSelectableInteraction(true);
        WatchUi.requestUpdate();
    }

    public function onUpdate(dc) {
        dc.setColor(_background, _background);
        dc.clear();
        View.onUpdate(dc);
    }

    public function activate(action) {
        return false;
    }
}
