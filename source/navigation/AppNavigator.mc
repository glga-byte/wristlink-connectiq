import Toybox.Lang;
import Toybox.WatchUi;

module AppRoute {
    const ROUTE_HOME = :home;
    const ROUTE_MENU = :menu;
    const ROUTE_RECENT = :recent;
    const ROUTE_NOTES = :notes;
    const ROUTE_STATUS = :status;
    const ROUTE_ABOUT = :about;
    const ROUTE_NAVIGATION = :navigation;
    const ROUTE_TIMER = :timer;
    const ROUTE_NOTE = :note;
}

class AppNavigationHooks {
    public function initialize() {
    }

    public function pushPair(pair as Array) {
    }

    public function popPair() {
    }
}

class AppNavigator {
    private var _session;
    private var _navigationHooks as AppNavigationHooks or Null;

    public function initialize(session, navigationHooks as AppNavigationHooks or Null) {
        _session = session;
        _navigationHooks = navigationHooks;
    }

    public function initialView() as Array {
        return pairForRoute(AppRoute.ROUTE_HOME);
    }

    public function pairForRoute(route) as Array or Null {
        if (route == AppRoute.ROUTE_MENU) {
            return [new Rez.Menus.DestinationMenu(), new DestinationMenuDelegate(self)];
        }

        var view = null;
        if (route == AppRoute.ROUTE_HOME) {
            view = new HomeView(_session, self);
        } else if (route == AppRoute.ROUTE_RECENT) {
            view = new RecentItemsView(_session, self);
        } else if (route == AppRoute.ROUTE_NOTES) {
            view = new SavedNotesView(_session, self);
        } else if (route == AppRoute.ROUTE_STATUS) {
            view = new StatusView(_session, self);
        } else if (route == AppRoute.ROUTE_ABOUT) {
            view = new AboutView(_session, self);
        } else if (route == AppRoute.ROUTE_NAVIGATION) {
            view = new ReceivedNavigationView(_session, self);
        } else if (route == AppRoute.ROUTE_TIMER) {
            view = new ReceivedTimerView(_session, self);
        } else if (route == AppRoute.ROUTE_NOTE) {
            view = new ReceivedNoteView(_session, self);
        }

        if (view == null) {
            return null;
        }
        return [view, new ScreenDelegate(view, self)];
    }

    private function pushPair(pair as Array) {
        if (_navigationHooks != null) {
            _navigationHooks.pushPair(pair);
        } else {
            WatchUi.pushView(pair[0], pair[1], WatchUi.SLIDE_UP);
        }
    }

    public function showRoute(route) {
        var pair = pairForRoute(route);
        if (pair != null) {
            pushPair(pair);
        }
    }

    public function showMenu() {
        pushPair(pairForRoute(AppRoute.ROUTE_MENU));
    }

    public function back() {
        if (_navigationHooks != null) {
            _navigationHooks.popPair();
        } else {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
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
