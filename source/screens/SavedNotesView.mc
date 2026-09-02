import Toybox.Graphics;

class SavedNotesView extends WristLinkView {
    public function initialize(session, navigator) {
        WristLinkView.initialize(session, navigator);
    }

    protected function buildLayout(m) {
        var layout = [];
        var note = _session.selectedNote();
        var iconSize = 36;
        var iconY = m.y(28, 64);
        var iconX = (m.width - iconSize) / 2;
        var bodyY = m.y(122, 190);
        var buttonY = m.y(208, 324);
        var noteNumber = _session.selectedNoteIndex() + 1;

        layout.add(new UiIconDrawable(iconX, iconY, iconSize, UiTheme.INK, Graphics.COLOR_WHITE, UiIconKind.NOTE));
        layout.add(UiFactory.centeredText("SAVED NOTES", m, m.y(72, 112), Graphics.FONT_XTINY, UiTheme.TEAL));
        layout.add(UiFactory.centeredText(note.title, m, m.y(90, 138), Graphics.FONT_LARGE, UiTheme.INK));
        layout.add(UiFactory.textArea(note.body, m.contentX, bodyY, m.contentWidth, m.y(54, 82), Graphics.FONT_SMALL, UiTheme.INK, Graphics.TEXT_JUSTIFY_CENTER));
        layout.add(UiFactory.centeredText(noteNumber + " of " + _session.noteCount() + "  •  " + note.savedSummary, m, m.y(176, 286), Graphics.FONT_XTINY, UiTheme.MUTED_LIGHT));
        layout.add(UiFactory.button(UiFactory.string(Rez.Strings.Next), :primary, :onPrimary, (m.width / 2) - 82, buttonY, 72, 40, false, true));
        layout.add(UiFactory.button(UiFactory.string(Rez.Strings.Menu), :secondary, :onSecondary, (m.width / 2) + 2, buttonY, 80, 40, false, false));
        return layout;
    }

    public function activate(action) {
        if (action == :primary) {
            _session.selectNextNote();
            rebuild();
            return true;
        } else if (action == :secondary) {
            _navigator.showMenu();
            return true;
        }
        return false;
    }
}
