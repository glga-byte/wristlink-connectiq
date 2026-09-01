import Toybox.Graphics;
import Toybox.WatchUi;

module UiFactory {
    function text(value, x, y, width, font, color, justification) {
        var anchorX = x;
        if (justification == Graphics.TEXT_JUSTIFY_CENTER) {
            anchorX = x + (width / 2);
        } else if (justification == Graphics.TEXT_JUSTIFY_RIGHT) {
            anchorX = x + width;
        }
        return new WatchUi.Text({
            :text => value,
            :locX => anchorX,
            :locY => y,
            :width => width,
            :height => 40,
            :font => font,
            :color => color,
            :justification => justification
        });
    }

    function centeredText(value, metrics, y, font, color) {
        return text(value, 0, y, metrics.width, font, color, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function textArea(value, x, y, width, height, font, color, justification) {
        return new WatchUi.TextArea({
            :text => value,
            :locX => x,
            :locY => y,
            :width => width,
            :height => height,
            :font => font,
            :color => color,
            :justification => justification
        });
    }

    function button(label, identifier, behavior, x, y, width, height, isDark, isPrimary) {
        var normalBackground = isPrimary ? (isDark ? UiTheme.ACCENT : UiTheme.INK) : UiTheme.background(isDark);
        var normalForeground = isPrimary ? (isDark ? UiTheme.INK : Graphics.COLOR_WHITE) : UiTheme.foreground(isDark);
        var normalBorder = isPrimary ? null : (isDark ? UiTheme.BORDER_DARK : UiTheme.BORDER_LIGHT);
        var highlightedBackground = isPrimary ? UiTheme.TEAL : UiTheme.ACCENT;
        var highlightedForeground = UiTheme.INK;
        return new WatchUi.Button({
            :locX => x,
            :locY => y,
            :width => width,
            :height => height,
            :identifier => identifier,
            :behavior => behavior,
            :stateDefault => new UiButtonDrawable(label, width, height, normalBackground, normalForeground, normalBorder),
            :stateHighlighted => new UiButtonDrawable(label, width, height, highlightedBackground, highlightedForeground, null),
            :stateSelected => new UiButtonDrawable(label, width, height, UiTheme.TEAL, UiTheme.INK, null),
            :stateDisabled => new UiButtonDrawable(label, width, height, UiTheme.BORDER_LIGHT, UiTheme.MUTED_LIGHT, null)
        });
    }

    function row(item, identifier, x, y, width, height) {
        return new WatchUi.Selectable({
            :locX => x,
            :locY => y,
            :width => width,
            :height => height,
            :identifier => identifier,
            :stateDefault => new UiRowDrawable(item, width, height, UiTheme.LIGHT_SURFACE, UiTheme.INK, UiTheme.MUTED_LIGHT, UiTheme.TEAL),
            :stateHighlighted => new UiRowDrawable(item, width, height, UiTheme.ACCENT, UiTheme.INK, UiTheme.INK, UiTheme.INK),
            :stateSelected => new UiRowDrawable(item, width, height, UiTheme.TEAL, Graphics.COLOR_WHITE, Graphics.COLOR_WHITE, Graphics.COLOR_WHITE),
            :stateDisabled => new UiRowDrawable(item, width, height, UiTheme.BORDER_LIGHT, UiTheme.MUTED_LIGHT, UiTheme.MUTED_LIGHT, UiTheme.MUTED_LIGHT)
        });
    }

    function string(resourceId) {
        return WatchUi.loadResource(resourceId);
    }
}
