class UiMetrics {
    public var width;
    public var height;
    public var centerX;
    public var safeTop;
    public var safeBottom;
    public var contentX;
    public var contentWidth;
    public var isRound;

    public function initialize(width, height) {
        self.width = width;
        self.height = height;
        centerX = width / 2;
        isRound = (width == height);
        safeTop = isRound ? 14 : 16;
        safeBottom = height - (isRound ? 14 : 16);
        contentWidth = isRound ? ((width * 78) / 100) : (width - 32);
        contentX = (width - contentWidth) / 2;
    }

    public function y(roundValue, rectangleValue) {
        return isRound ? roundValue : rectangleValue;
    }

    public function top(roundOffset, rectangleOffset) {
        return safeTop + y(roundOffset, rectangleOffset);
    }

    public function bottom(roundOffset, rectangleOffset) {
        return safeBottom - y(roundOffset, rectangleOffset);
    }

    public function contains(x, y, itemWidth, itemHeight) {
        return x >= contentX &&
            (x + itemWidth) <= (contentX + contentWidth) &&
            y >= safeTop &&
            (y + itemHeight) <= safeBottom;
    }
}
