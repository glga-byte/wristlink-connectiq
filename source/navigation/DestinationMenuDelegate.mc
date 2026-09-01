import Toybox.WatchUi;

class DestinationMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _navigator;

    public function initialize(navigator) {
        Menu2InputDelegate.initialize();
        _navigator = navigator;
    }

    public function onSelect(item) {
        var route = _navigator.routeForMenuId(item.getId());
        if (route != null) {
            _navigator.showRoute(route);
        }
    }

    public function onBack() {
        _navigator.back();
    }
}
