import Toybox.WatchUi;

module AppRoute {
    const ROUTE_HOME = :home;
    const ROUTE_RECENT = :recent;
    const ROUTE_NOTES = :notes;
    const ROUTE_STATUS = :status;
    const ROUTE_ABOUT = :about;
    const ROUTE_NAVIGATION = :navigation;
    const ROUTE_TIMER = :timer;
    const ROUTE_NOTE = :note;
}

class AppNavigator {
    private var _session;

    public function initialize(session) {
        _session = session;
    }

    public function initialView() {
        return pairFor(new HomeView(_session, self));
    }

    private function pairFor(view) {
        return [view, new ScreenDelegate(view, self)];
    }

    private function push(view) {
        WatchUi.pushView(view, new ScreenDelegate(view, self), WatchUi.SLIDE_UP);
    }

    public function showRoute(route) {
        if (route == AppRoute.ROUTE_RECENT) {
            push(new RecentItemsView(_session, self));
        } else if (route == AppRoute.ROUTE_NOTES) {
            push(new SavedNotesView(_session, self));
        } else if (route == AppRoute.ROUTE_STATUS) {
            push(new StatusView(_session, self));
        } else if (route == AppRoute.ROUTE_ABOUT) {
            push(new AboutView(_session, self));
        } else if (route == AppRoute.ROUTE_NAVIGATION) {
            push(new ReceivedNavigationView(_session, self));
        } else if (route == AppRoute.ROUTE_TIMER) {
            push(new ReceivedTimerView(_session, self));
        } else if (route == AppRoute.ROUTE_NOTE) {
            push(new ReceivedNoteView(_session, self));
        }
    }

    public function showMenu() {
        var menu = new Rez.Menus.DestinationMenu();
        WatchUi.pushView(menu, new DestinationMenuDelegate(self), WatchUi.SLIDE_UP);
    }

    public function back() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    public function routeForMenuId(id) {
        if (id == :recent) {
            return AppRoute.ROUTE_RECENT;
        } else if (id == :notes) {
            return AppRoute.ROUTE_NOTES;
        } else if (id == :status) {
            return AppRoute.ROUTE_STATUS;
        } else if (id == :about) {
            return AppRoute.ROUTE_ABOUT;
        }
        return null;
    }

    public function routeForRecentIndex(index) {
        if (index == 0) {
            return AppRoute.ROUTE_NAVIGATION;
        } else if (index == 1) {
            return AppRoute.ROUTE_NOTE;
        } else if (index == 2) {
            return AppRoute.ROUTE_TIMER;
        }
        return null;
    }
}
