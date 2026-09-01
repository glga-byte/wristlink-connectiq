import Toybox.Graphics;
import Toybox.Lang;

class RecentItemsView extends WristLinkView {
    public function initialize(session, navigator) {
        WristLinkView.initialize(session, navigator);
    }

    protected function buildLayout(m) {
        var layout = [];
        var titleY = m.y(28, 48);
        var rowY = m.y(68, 112);
        var rowHeight = 48;
        var gap = m.y(6, 16);
        var items = _session.recentItems() as Array<DemoItem>;

        layout.add(UiFactory.centeredText("MENU", m, titleY - 18, Graphics.FONT_XTINY, UiTheme.TEAL));
        layout.add(UiFactory.centeredText("Recent items", m, titleY, Graphics.FONT_LARGE, UiTheme.INK));
        for (var i = 0; i < items.size(); i += 1) {
            layout.add(UiFactory.row(items[i], i, m.contentX, rowY + (i * (rowHeight + gap)), m.contentWidth, rowHeight));
        }
        layout.add(UiFactory.centeredText("Select opens item · Menu switches view", m, m.y(244, 320), Graphics.FONT_XTINY, UiTheme.MUTED_LIGHT));
        return layout;
    }

    public function activate(action) {
        if (action instanceof Number) {
            var route = _navigator.routeForRecentIndex(action);
            if (route != null) {
                _navigator.showRoute(route);
                return true;
            }
        }
        return false;
    }
}
