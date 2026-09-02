import Toybox.Lang;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class NavigationTestStack extends AppNavigationHooks {
    private var _pairs as Array<Array>;

    public function initialize() {
        AppNavigationHooks.initialize();
        _pairs = [] as Array<Array>;
    }

    public function setInitial(pair as Array) {
        _pairs.add(pair);
    }

    public function pushPair(pair as Array) {
        _pairs.add(pair);
    }

    public function popPair() {
        if (_pairs.size() > 1) {
            _pairs.remove(_pairs[_pairs.size() - 1]);
        }
    }

    public function size() {
        return _pairs.size();
    }

    public function topPair() as Array {
        return _pairs[_pairs.size() - 1];
    }
}

(:test)
function testNavigatorRouteMappings(logger) {
    var navigator = new AppNavigator(new DemoSession(), null);
    Test.assertEqual(navigator.routeForMenuId(:recent), AppRoute.ROUTE_RECENT);
    Test.assertEqual(navigator.routeForMenuId(:notes), AppRoute.ROUTE_NOTES);
    Test.assertEqual(navigator.routeForMenuId(:status), AppRoute.ROUTE_STATUS);
    Test.assertEqual(navigator.routeForMenuId(:about), AppRoute.ROUTE_ABOUT);
    Test.assertEqual(navigator.routeForRecentIndex(0), AppRoute.ROUTE_NAVIGATION);
    Test.assertEqual(navigator.routeForRecentIndex(1), AppRoute.ROUTE_NOTE);
    Test.assertEqual(navigator.routeForRecentIndex(2), AppRoute.ROUTE_TIMER);
    Test.assert(navigator.routeForMenuId(:unknown) == null);
    Test.assert(navigator.routeForRecentIndex(3) == null);
    return true;
}

(:test)
function testNavigatorCreatesEveryViewDelegatePair(logger) {
    var navigator = new AppNavigator(new DemoSession(), null);
    var pair = navigator.pairForRoute(AppRoute.ROUTE_HOME);
    Test.assert(pair[0] instanceof HomeView);
    Test.assert(pair[1] instanceof ScreenDelegate);

    pair = navigator.pairForRoute(AppRoute.ROUTE_MENU);
    Test.assert(pair[0] instanceof WatchUi.Menu2);
    Test.assert(pair[1] instanceof DestinationMenuDelegate);

    pair = navigator.pairForRoute(AppRoute.ROUTE_RECENT);
    Test.assert(pair[0] instanceof RecentItemsView);
    Test.assert(pair[1] instanceof ScreenDelegate);
    pair = navigator.pairForRoute(AppRoute.ROUTE_NOTES);
    Test.assert(pair[0] instanceof SavedNotesView);
    Test.assert(pair[1] instanceof ScreenDelegate);
    pair = navigator.pairForRoute(AppRoute.ROUTE_STATUS);
    Test.assert(pair[0] instanceof StatusView);
    Test.assert(pair[1] instanceof ScreenDelegate);
    pair = navigator.pairForRoute(AppRoute.ROUTE_ABOUT);
    Test.assert(pair[0] instanceof AboutView);
    Test.assert(pair[1] instanceof ScreenDelegate);

    pair = navigator.pairForRoute(AppRoute.ROUTE_NAVIGATION);
    Test.assert(pair[0] instanceof ReceivedNavigationView);
    Test.assert(pair[1] instanceof ScreenDelegate);
    pair = navigator.pairForRoute(AppRoute.ROUTE_NOTE);
    Test.assert(pair[0] instanceof ReceivedNoteView);
    Test.assert(pair[1] instanceof ScreenDelegate);
    pair = navigator.pairForRoute(AppRoute.ROUTE_TIMER);
    Test.assert(pair[0] instanceof ReceivedTimerView);
    Test.assert(pair[1] instanceof ScreenDelegate);
    Test.assert(navigator.pairForRoute(:unknown) == null);
    return true;
}

(:test)
function testDestinationMenuResourceOrderAndSelection(logger) {
    var stack = new NavigationTestStack();
    var navigator = new AppNavigator(new DemoSession(), stack);
    stack.setInitial(navigator.initialView());
    navigator.showMenu();

    var menuPair = stack.topPair();
    var menu = menuPair[0];
    var delegate = menuPair[1];
    var ids = [:recent, :notes, :status, :about];
    var labels = ["Recent Items", "Saved Notes", "Status", "About"];

    for (var i = 0; i < ids.size(); i += 1) {
        var item = menu.getItem(i);
        Test.assert(item != null);
        Test.assertEqual(item.getId(), ids[i]);
        Test.assertEqual(item.getLabel(), labels[i]);

        delegate.onSelect(item);
        if (i == 0) {
            Test.assert(stack.topPair()[0] instanceof RecentItemsView);
        } else if (i == 1) {
            Test.assert(stack.topPair()[0] instanceof SavedNotesView);
        } else if (i == 2) {
            Test.assert(stack.topPair()[0] instanceof StatusView);
        } else {
            Test.assert(stack.topPair()[0] instanceof AboutView);
        }
        navigator.back();
        Test.assert(stack.topPair()[1] instanceof DestinationMenuDelegate);
    }
    Test.assert(menu.getItem(4) == null);
    return true;
}

(:test)
function testBackFromEveryMenuDestinationReturnsToMenu(logger) {
    var routes = [
        AppRoute.ROUTE_RECENT,
        AppRoute.ROUTE_NOTES,
        AppRoute.ROUTE_STATUS,
        AppRoute.ROUTE_ABOUT
    ];

    for (var i = 0; i < routes.size(); i += 1) {
        var stack = new NavigationTestStack();
        var navigator = new AppNavigator(new DemoSession(), stack);
        stack.setInitial(navigator.initialView());
        navigator.showMenu();
        navigator.showRoute(routes[i]);
        Test.assertEqual(stack.size(), 3);
        navigator.back();
        Test.assertEqual(stack.size(), 2);
        Test.assert(stack.topPair()[1] instanceof DestinationMenuDelegate);
        navigator.back();
        Test.assertEqual(stack.size(), 1);
        Test.assert(stack.topPair()[0] instanceof HomeView);
    }
    return true;
}

(:test)
function testBackFromEveryReceivedDetailReturnsToRecentItems(logger) {
    for (var i = 0; i < 3; i += 1) {
        var stack = new NavigationTestStack();
        var navigator = new AppNavigator(new DemoSession(), stack);
        stack.setInitial(navigator.initialView());
        navigator.showMenu();
        navigator.showRoute(AppRoute.ROUTE_RECENT);
        navigator.showRoute(navigator.routeForRecentIndex(i));
        Test.assertEqual(stack.size(), 4);
        navigator.back();
        Test.assertEqual(stack.size(), 3);
        Test.assert(stack.topPair()[0] instanceof RecentItemsView);
    }
    return true;
}
