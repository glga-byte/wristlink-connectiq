import Toybox.Graphics;

class ReceivedNoteView extends WristLinkView {
    public function initialize(session, navigator) {
        WristLinkView.initialize(session, navigator);
    }

    public function isDark() {
        return true;
    }

    protected function buildLayout(m) {
        var layout = [];
        var iconSize = 42;
        var iconY = m.y(42, 82);
        var iconX = (m.width - iconSize) / 2;
        layout.add(new UiIconDrawable(iconX, iconY, iconSize, UiTheme.ACCENT, UiTheme.INK, "N"));
        layout.add(UiFactory.centeredText("NOTE RECEIVED", m, m.y(94, 144), Graphics.FONT_XTINY, UiTheme.ACCENT));
        layout.add(UiFactory.centeredText(DemoData.NOTE_TITLE, m, m.y(116, 174), Graphics.FONT_LARGE, Graphics.COLOR_WHITE));
        layout.add(UiFactory.textArea(DemoData.NOTE_BODY, m.contentX, m.y(150, 220), m.contentWidth, m.y(54, 68), Graphics.FONT_SMALL, Graphics.COLOR_WHITE, Graphics.TEXT_JUSTIFY_CENTER));
        layout.add(UiFactory.button(UiFactory.string(Rez.Strings.SaveNote), :primary, :onPrimary, (m.width - 154) / 2, m.y(210, 310), 154, 42, true, true));
        return layout;
    }

    public function activate(action) {
        if (action == :primary) {
            _session.saveReceivedNote();
            _navigator.showRoute(AppRoute.ROUTE_NOTES);
            return true;
        }
        return false;
    }
}
