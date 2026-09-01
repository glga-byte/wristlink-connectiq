import Toybox.WatchUi;

class ScreenDelegate extends WatchUi.BehaviorDelegate {
    private var _view;
    private var _navigator;

    public function initialize(view, navigator) {
        BehaviorDelegate.initialize();
        _view = view;
        _navigator = navigator;
    }

    public function onPrimary() {
        return _view.activate(:primary);
    }

    public function onSecondary() {
        return _view.activate(:secondary);
    }

    public function onTertiary() {
        return _view.activate(:tertiary);
    }

    public function onSelectable(event) {
        var selectable = event.getInstance();
        if (selectable.getState() == :stateSelected) {
            return _view.activate(selectable.identifier);
        }
        return true;
    }

    public function onMenu() {
        _navigator.showMenu();
        return true;
    }

    public function onNextPage() {
        return _view.activate(:primary);
    }

    public function onBack() {
        _navigator.back();
        return true;
    }
}
