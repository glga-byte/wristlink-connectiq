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
        dc.fillRoundedRectangle(locX, locY, width, height, 14);
        if (_border != null) {
            dc.setColor(_border, Graphics.COLOR_TRANSPARENT);
            dc.drawRoundedRectangle(locX, locY, width, height, 14);
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
        var font = Graphics.FONT_SMALL;
        var textY = locY + ((height - dc.getFontHeight(font)) / 2);
        dc.drawText(locX + (width / 2), textY, font, _label, Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class UiRowDrawable extends WatchUi.Drawable {
    private var _item;
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
        _item = item;
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
        dc.fillRoundedRectangle(locX, locY, width, height, 12);
        dc.setColor(_accent, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(locX + 14, locY + (height / 2), 5);
        dc.setColor(_foreground, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX + 26, locY + 4, Graphics.FONT_XTINY, _item.title, Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(_muted, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX + 26, locY + 22, Graphics.FONT_XTINY, _item.type + " · " + _item.status, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(locX + width - 8, locY + 13, Graphics.FONT_XTINY, _item.status, Graphics.TEXT_JUSTIFY_RIGHT);
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
            :height => 8,
            :visible => true
        });
        _percent = percent;
        _track = track;
        _fill = fill;
    }

    public function draw(dc) {
        if (!isVisible) {
            return;
        }
        dc.setColor(_track, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(locX, locY, width, height, 4);
        dc.setColor(_fill, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(locX, locY, (width * _percent) / 100, height, 4);
    }
}

class UiIconDrawable extends WatchUi.Drawable {
    private var _size;
    private var _background;
    private var _foreground;
    private var _letter;

    public function initialize(x, y, size, background, foreground, letter) {
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
        _letter = letter;
    }

    public function draw(dc) {
        if (!isVisible) {
            return;
        }
        dc.setColor(_background, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(locX + (_size / 2), locY + (_size / 2), _size / 2);
        dc.setColor(_foreground, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX + (_size / 2), locY + ((_size - dc.getFontHeight(Graphics.FONT_SMALL)) / 2),
            Graphics.FONT_SMALL, _letter, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
