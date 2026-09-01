import Toybox.Graphics;

class HomeView extends WristLinkView {
    public function initialize(session, navigator) {
        WristLinkView.initialize(session, navigator);
    }

    public function isDark() {
        return _session.hasPending();
    }

    protected function buildLayout(m) {
        var dark = isDark();
        var foreground = UiTheme.foreground(dark);
        var muted = UiTheme.muted(dark);
        var layout = [];
        var badgeY = m.y(18, 54);
        var eyebrowY = m.y(44, 88);
        var titleY = m.y(60, 106);
        var cardY = m.y(98, 154);
        var cardHeight = m.y(82, 112);
        var summaryY = m.y(184, 286);
        var buttonY = m.y(208, 330);
        var buttonWidth = m.y(148, 190);
        var buttonX = (m.width - buttonWidth) / 2;

        layout.add(UiFactory.centeredText("•  Phone connected", m, badgeY, Graphics.FONT_XTINY, dark ? UiTheme.ACCENT : UiTheme.INK));
        layout.add(UiFactory.centeredText("WRISTLINK", m, eyebrowY, Graphics.FONT_XTINY, dark ? UiTheme.ACCENT : UiTheme.TEAL));
        layout.add(UiFactory.centeredText("Inbox", m, titleY, Graphics.FONT_LARGE, foreground));

        var cardColor = dark ? UiTheme.LIGHT_BACKGROUND : UiTheme.LIGHT_SURFACE;
        layout.add(new UiCardDrawable(m.contentX, cardY, m.contentWidth, cardHeight, cardColor, null));
        layout.add(UiFactory.centeredText(dark ? "PENDING" : "READY", m, cardY + m.y(6, 10), Graphics.FONT_XTINY, UiTheme.TEAL));
        layout.add(UiFactory.centeredText(dark ? DemoData.NAVIGATION_TITLE : "No pending requests", m, cardY + m.y(24, 34), Graphics.FONT_SMALL, UiTheme.INK));
        layout.add(UiFactory.centeredText(dark ? DemoData.NAVIGATION_DESTINATION : "Send from phone", m, cardY + m.y(54, 70), Graphics.FONT_XTINY, UiTheme.MUTED_LIGHT));

        var pendingCount = dark ? 1 : 0;
        var summary = pendingCount + " pending  •  " + _session.recentSummaryCount() + " recent  •  " + _session.noteCount() + " notes";
        layout.add(UiFactory.centeredText(summary, m, summaryY, Graphics.FONT_XTINY, muted));
        var label = dark ? UiFactory.string(Rez.Strings.Open) : UiFactory.string(Rez.Strings.Recent);
        layout.add(UiFactory.button(label, :primary, :onPrimary, buttonX, buttonY, buttonWidth, 42, dark, true));
        return layout;
    }

    public function activate(action) {
        if (action == :primary) {
            _navigator.showRoute(_session.hasPending() ? AppRoute.ROUTE_NAVIGATION : AppRoute.ROUTE_RECENT);
            return true;
        }
        return false;
    }
}
