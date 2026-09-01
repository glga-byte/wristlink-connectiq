import Toybox.Graphics;

class ReceivedTimerView extends WristLinkView {
    public function initialize(session, navigator) {
        WristLinkView.initialize(session, navigator);
    }

    public function isDark() {
        return true;
    }

    protected function buildLayout(m) {
        var layout = [];
        var started = (_session.timerOutcome() == DemoSessionState.TIMER_STARTED);
        layout.add(UiFactory.centeredText(started ? "TIMER STARTED" : "TIMER RECEIVED", m, m.y(72, 122), Graphics.FONT_XTINY, UiTheme.ACCENT));
        layout.add(UiFactory.centeredText(started ? "Started" : DemoData.TIMER_DURATION_LABEL, m, m.y(94, 156), Graphics.FONT_NUMBER_HOT, Graphics.COLOR_WHITE));
        layout.add(UiFactory.centeredText(DemoData.TIMER_LABEL, m, m.y(150, 228), Graphics.FONT_SMALL, Graphics.COLOR_WHITE));
        layout.add(new UiProgressDrawable(m.contentX + 18, m.y(180, 270), m.contentWidth - 36, started ? 100 : 34, UiTheme.BORDER_DARK, UiTheme.ACCENT));
        layout.add(UiFactory.button(started ? UiFactory.string(Rez.Strings.Done) : UiFactory.string(Rez.Strings.StartTimer), :primary, :onPrimary, (m.width - 168) / 2, m.y(202, 306), 168, 44, true, true));
        return layout;
    }

    public function activate(action) {
        if (action == :primary) {
            if (_session.timerOutcome() == DemoSessionState.TIMER_STARTED) {
                _navigator.back();
            } else {
                _session.startTimer();
                rebuild();
            }
            return true;
        }
        return false;
    }
}
