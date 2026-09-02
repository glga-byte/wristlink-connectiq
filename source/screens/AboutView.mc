import Toybox.Graphics;
import Toybox.Lang;

class AboutView extends WristLinkView {
    public function initialize(session, navigator) {
        WristLinkView.initialize(session, navigator);
    }

    protected function buildLayout(m) {
        var layout = [];
        var about = DemoData.about() as Dictionary<String, String>;
        var iconSize = 36;
        var iconY = m.y(28, 64);
        var iconX = (m.width - iconSize) / 2;
        var cardY = m.y(128, 190);
        var cardHeight = 36;
        var gap = m.y(7, 14);
        var labels = ["App", "Contract", "UUID"] as Array<String>;
        var values = [about["platform"], about["contract"], about["uuid"]] as Array<String>;

        layout.add(new UiIconDrawable(iconX, iconY, iconSize, UiTheme.INK, Graphics.COLOR_WHITE, UiIconKind.LOGO));
        layout.add(UiFactory.centeredText("ABOUT", m, m.y(72, 112), Graphics.FONT_XTINY, UiTheme.TEAL));
        layout.add(UiFactory.centeredText(about["name"], m, m.y(92, 140), Graphics.FONT_LARGE, UiTheme.INK));
        for (var i = 0; i < labels.size(); i += 1) {
            var y = cardY + (i * (cardHeight + gap));
            layout.add(new UiCardDrawable(m.contentX, y, m.contentWidth, cardHeight, UiTheme.LIGHT_SURFACE, null));
            layout.add(UiFactory.text(labels[i], m.contentX + 14, y + 8, 70, Graphics.FONT_XTINY, UiTheme.INK, Graphics.TEXT_JUSTIFY_LEFT));
            if (i < 2) {
                layout.add(UiFactory.text(values[i], m.contentX + 80, y + 8, m.contentWidth - 94, Graphics.FONT_XTINY, UiTheme.MUTED_LIGHT, Graphics.TEXT_JUSTIFY_RIGHT));
            } else {
                layout.add(UiFactory.textArea(values[i], m.contentX + 80, y + 2, m.contentWidth - 94, cardHeight, Graphics.FONT_XTINY, UiTheme.MUTED_LIGHT, Graphics.TEXT_JUSTIFY_RIGHT));
            }
        }
        layout.add(UiFactory.centeredText("Back returns to menu", m, m.y(254, 360), Graphics.FONT_XTINY, UiTheme.MUTED_LIGHT));
        return layout;
    }
}
