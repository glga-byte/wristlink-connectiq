import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class ActivationTestView {
    public var actions as Array<Object>;

    public function initialize() {
        actions = [] as Array<Object>;
    }

    public function activate(actionId) {
        actions.add(actionId);
        return true;
    }
}

(:test)
function testUiFactoryBuildsManagedScreenComponents(logger) {
    var item = DemoData.recentItems()[0];
    var text = UiFactory.text("Label", 0, 0, 100, Graphics.FONT_SMALL, Graphics.COLOR_WHITE, Graphics.TEXT_JUSTIFY_LEFT);
    var textArea = UiFactory.textArea("Wrapped label", 0, 0, 100, 40, Graphics.FONT_SMALL, Graphics.COLOR_WHITE, Graphics.TEXT_JUSTIFY_LEFT);
    var button = UiFactory.button("Open", :primary, :onPrimary, 0, 0, 100, 40, true, true);
    var row = UiFactory.row(item, 0, 0, 0, 100, 48);

    Test.assert(text instanceof WatchUi.Text);
    Test.assert(textArea instanceof WatchUi.TextArea);
    Test.assert(button instanceof WatchUi.Button);
    Test.assert(row instanceof WatchUi.Selectable);
    return true;
}

(:test)
function testPhysicalAndSelectableActivationShareSemanticAction(logger) {
    var view = new ActivationTestView();
    var delegate = new ScreenDelegate(view, null);

    Test.assert(delegate instanceof WatchUi.BehaviorDelegate);
    Test.assert(delegate.onPrimary());

    var button = UiFactory.button("Open", :primary, :onPrimary, 0, 0, 100, 40, true, true);
    button.setState(:stateSelected);
    var event = new WatchUi.SelectableEvent(button, :stateHighlighted);
    Test.assert(delegate.onSelectable(event));

    Test.assertEqual(view.actions.size(), 2);
    Test.assertEqual(view.actions[0], :primary);
    Test.assertEqual(view.actions[1], :primary);
    return true;
}

(:test)
function testSelectableOnlyActivatesWhenSelected(logger) {
    var view = new ActivationTestView();
    var delegate = new ScreenDelegate(view, null);
    var row = UiFactory.row(DemoData.recentItems()[0], 2, 0, 0, 100, 48);

    row.setState(:stateHighlighted);
    Test.assert(delegate.onSelectable(new WatchUi.SelectableEvent(row, :stateDefault)));
    Test.assertEqual(view.actions.size(), 0);

    row.setState(:stateSelected);
    Test.assert(delegate.onSelectable(new WatchUi.SelectableEvent(row, :stateHighlighted)));
    Test.assertEqual(view.actions.size(), 1);
    Test.assertEqual(view.actions[0], 2);
    return true;
}
