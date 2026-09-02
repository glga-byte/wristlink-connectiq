import Toybox.Graphics;
import Toybox.WatchUi;

class UiCardDrawable extends WatchUi.Drawable {
    private var _color;
    private var _border;

    public function initialize(x, y, width, height, color, border) {
        Drawable.initialize({
            :locX => x,
            :locY => y,
            :width => width,
            :height => height,
            :visible => true
        });
        _color = color;
        _border = border;
    }

    public function draw(dc) {
        if (!isVisible) {
            return;
        }
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(locX, locY, width, height, UiTheme.CARD_RADIUS);
        if (_border != null) {
            dc.setColor(_border, Graphics.COLOR_TRANSPARENT);
            dc.drawRoundedRectangle(locX, locY, width, height, UiTheme.CARD_RADIUS);
        }
    }
}

class UiButtonDrawable extends WatchUi.Drawable {
    private var _label;
    private var _background;
    private var _foreground;
    private var _border;

    public function initialize(label, width, height, background, foreground, border) {
        Drawable.initialize({
            :locX => 0,
            :locY => 0,
            :width => width,
            :height => height,
            :visible => true
        });
        _label = label;
        _background = background;
        _foreground = foreground;
        _border = border;
    }

    public function draw(dc) {
        if (!isVisible) {
            return;
        }
        dc.setColor(_background, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(locX, locY, width, height, height / 2);
        if (_border != null) {
            dc.setColor(_border, Graphics.COLOR_TRANSPARENT);
            dc.drawRoundedRectangle(locX, locY, width, height, height / 2);
        }
        dc.setColor(_foreground, Graphics.COLOR_TRANSPARENT);
        var font = UiTypography.BODY;
        var textY = locY + ((height - dc.getFontHeight(font)) / 2);
        dc.drawText(locX + (width / 2), textY, font, _label, Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class UiRowDrawable extends WatchUi.Drawable {
    private var _title;
    private var _detail;
    private var _status;
    private var _background;
    private var _foreground;
    private var _muted;
    private var _accent;

    public function initialize(item, width, height, background, foreground, muted, accent) {
        Drawable.initialize({
            :locX => 0,
            :locY => 0,
            :width => width,
            :height => height,
            :visible => true
        });
        _title = item.title;
        _detail = item.type + " · " + item.status;
        _status = item.status;
        _background = background;
        _foreground = foreground;
        _muted = muted;
        _accent = accent;
    }

    public function draw(dc) {
        if (!isVisible) {
            return;
        }
        dc.setColor(_background, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(locX, locY, width, height, UiTheme.ROW_RADIUS);
        dc.setColor(_accent, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(locX + 14, locY + (height / 2), 5);
        dc.setColor(_foreground, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX + 26, locY + 4, UiTypography.CAPTION, _title, Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(_muted, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX + 26, locY + 22, UiTypography.CAPTION, _detail, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(locX + width - 8, locY + 13, UiTypography.CAPTION, _status, Graphics.TEXT_JUSTIFY_RIGHT);
    }
}

class UiProgressDrawable extends WatchUi.Drawable {
    private var _percent;
    private var _track;
    private var _fill;

    public function initialize(x, y, width, percent, track, fill) {
        Drawable.initialize({
            :locX => x,
            :locY => y,
            :width => width,
            :height => UiTheme.PROGRESS_HEIGHT,
            :visible => true
        });
        _percent = percent < 0 ? 0 : (percent > 100 ? 100 : percent);
        _track = track;
        _fill = fill;
    }

    public function draw(dc) {
        if (!isVisible) {
            return;
        }
        dc.setColor(_track, Graphics.COLOR_TRANSPARENT);
        var radius = height / 2;
        dc.fillRoundedRectangle(locX, locY, width, height, radius);
        if (_percent > 0) {
            dc.setColor(_fill, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(locX, locY, (width * _percent) / 100, height, radius);
        }
    }
}

module UiIconKind {
    const LOGO = 0;
    const NAVIGATION = 1;
    const NOTE = 2;
    const CONFIRM = 3;
}

class UiIconDrawable extends WatchUi.Drawable {
    private var _size;
    private var _background;
    private var _foreground;
    private var _kind;

    public function initialize(x, y, size, background, foreground, kind) {
        Drawable.initialize({
            :locX => x,
            :locY => y,
            :width => size,
            :height => size,
            :visible => true
        });
        _size = size;
        _background = background;
        _foreground = foreground;
        _kind = kind;
    }

    public function draw(dc) {
        if (!isVisible) {
            return;
        }
        dc.setColor(_background, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(locX + (_size / 2), locY + (_size / 2), _size / 2);
        dc.setColor(_foreground, Graphics.COLOR_TRANSPARENT);
        var cx = locX + (_size / 2);
        var cy = locY + (_size / 2);
        var inset = _size / 4;
        if (_kind == UiIconKind.NAVIGATION) {
            dc.drawLine(cx - inset, cy + inset, cx + inset, cy - inset);
            dc.drawLine(cx + inset, cy - inset, cx + inset, cy);
            dc.drawLine(cx + inset, cy - inset, cx, cy - inset);
        } else if (_kind == UiIconKind.NOTE) {
            dc.drawRoundedRectangle(cx - inset, cy - inset, inset * 2, inset * 2, 2);
            dc.drawLine(cx - (inset / 2), cy - (inset / 3), cx + (inset / 2), cy - (inset / 3));
            dc.drawLine(cx - (inset / 2), cy + (inset / 3), cx + (inset / 2), cy + (inset / 3));
        } else if (_kind == UiIconKind.CONFIRM) {
            dc.drawLine(cx - inset, cy, cx - (inset / 4), cy + inset);
            dc.drawLine(cx - (inset / 4), cy + inset, cx + inset, cy - inset);
        } else {
            dc.drawLine(cx - inset, cy - inset, cx - (inset / 2), cy + inset);
            dc.drawLine(cx - (inset / 2), cy + inset, cx, cy);
            dc.drawLine(cx, cy, cx + (inset / 2), cy + inset);
            dc.drawLine(cx + (inset / 2), cy + inset, cx + inset, cy - inset);
        }
    }
}
