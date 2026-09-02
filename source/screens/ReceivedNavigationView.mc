import Toybox.Graphics;

class ReceivedNavigationView extends WristLinkView {
    public function initialize(session, navigator) {
        WristLinkView.initialize(session, navigator);
    }

    public function isDark() {
        return true;
    }

    protected function buildLayout(m) {
        var layout = [];
        var launched = (_session.navigationOutcome() == DemoSessionState.NAVIGATION_LAUNCHED);
        var iconSize = 42;
        var iconY = m.y(52, 100);
        var iconX = (m.width - iconSize) / 2;

        layout.add(new UiIconDrawable(iconX, iconY, iconSize, UiTheme.ACCENT, UiTheme.INK, launched ? UiIconKind.CONFIRM : UiIconKind.NAVIGATION));
        layout.add(UiFactory.centeredText(launched ? "LOCAL OUTCOME" : "PHONE REQUEST", m, m.y(104, 166), UiTypography.EYEBROW, UiTheme.ACCENT));
        layout.add(UiFactory.centeredText(launched ? "Ready to launch" : "Launch navigation?", m, m.y(124, 194), UiTypography.TITLE, Graphics.COLOR_WHITE));
        layout.add(UiFactory.centeredText(DemoData.NAVIGATION_DESTINATION, m, m.y(158, 238), UiTypography.BODY, UiTheme.MUTED_DARK));
        if (launched) {
            layout.add(UiFactory.centeredText("No external app was opened", m, m.y(184, 276), UiTypography.CAPTION, UiTheme.MUTED_DARK));
            layout.add(UiFactory.button(UiFactory.string(Rez.Strings.Done), :primary, :onPrimary, (m.width - 130) / 2, m.y(212, 324), 130, 42, true, true));
        } else {
            layout.add(UiFactory.button(UiFactory.string(Rez.Strings.Launch), :primary, :onPrimary, (m.width / 2) - 108, m.y(196, 302), 100, 42, true, true));
            layout.add(UiFactory.button(UiFactory.string(Rez.Strings.Later), :secondary, :onSecondary, (m.width / 2) + 8, m.y(196, 302), 86, 42, true, false));
        }
        return layout;
    }

    public function activate(action) {
        if (_session.navigationOutcome() == DemoSessionState.NAVIGATION_LAUNCHED) {
            if (action == :primary) {
                _navigator.back();
                return true;
            }
        } else if (action == :primary) {
            _session.launchNavigation();
            rebuild();
            return true;
        } else if (action == :secondary) {
            _session.deferNavigation();
            _navigator.back();
            return true;
        }
        return false;
    }
}
