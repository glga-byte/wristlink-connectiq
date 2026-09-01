import Toybox.Test;

(:test)
function testNavigatorRouteMappings(logger) {
    var navigator = new AppNavigator(new DemoSession());
    Test.assertEqual(navigator.routeForMenuId(:recent), AppRoute.ROUTE_RECENT);
    Test.assertEqual(navigator.routeForMenuId(:notes), AppRoute.ROUTE_NOTES);
    Test.assertEqual(navigator.routeForMenuId(:status), AppRoute.ROUTE_STATUS);
    Test.assertEqual(navigator.routeForMenuId(:about), AppRoute.ROUTE_ABOUT);
    Test.assertEqual(navigator.routeForRecentIndex(0), AppRoute.ROUTE_NAVIGATION);
    Test.assertEqual(navigator.routeForRecentIndex(1), AppRoute.ROUTE_NOTE);
    Test.assertEqual(navigator.routeForRecentIndex(2), AppRoute.ROUTE_TIMER);
    Test.assertEqual(navigator.routeForRecentIndex(3), null);
    return true;
}
