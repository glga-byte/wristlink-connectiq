import Toybox.Graphics;
import Toybox.Lang;

class StatusView extends WristLinkView {
    public function initialize(session, navigator) {
        WristLinkView.initialize(session, navigator);
    }

    protected function buildLayout(m) {
        var layout = [];
        var status = DemoData.status() as Dictionary<String, String>;
        var cardY = m.y(106, 170);
        var cardHeight = 38;
        var gap = m.y(7, 16);
        var labels = ["Phone link", "Last ack", "Contract"] as Array<String>;
        var values = [status["phoneLink"], status["lastAck"], status["contract"]] as Array<String>;

        layout.add(UiFactory.centeredText("STATUS", m, m.y(32, 58), Graphics.FONT_XTINY, UiTheme.TEAL));
        layout.add(UiFactory.centeredText(status["readiness"], m, m.y(52, 86), Graphics.FONT_LARGE, UiTheme.INK));
        layout.add(new UiProgressDrawable(m.contentX + 12, m.y(88, 138), m.contentWidth - 24, 72, UiTheme.BORDER_LIGHT, UiTheme.ACCENT));
        for (var i = 0; i < labels.size(); i += 1) {
            var y = cardY + (i * (cardHeight + gap));
            layout.add(new UiCardDrawable(m.contentX, y, m.contentWidth, cardHeight, UiTheme.LIGHT_SURFACE, null));
            layout.add(UiFactory.text(labels[i], m.contentX + 16, y + 8, m.contentWidth / 2, Graphics.FONT_XTINY, UiTheme.INK, Graphics.TEXT_JUSTIFY_LEFT));
            layout.add(UiFactory.text(values[i], m.centerX, y + 8, (m.contentWidth / 2) - 16, Graphics.FONT_XTINY, UiTheme.MUTED_LIGHT, Graphics.TEXT_JUSTIFY_RIGHT));
        }
        layout.add(UiFactory.centeredText("Back returns to menu", m, m.y(245, 360), Graphics.FONT_XTINY, UiTheme.MUTED_LIGHT));
        return layout;
    }
}
