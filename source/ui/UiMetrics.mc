class UiMetrics {
    public var width;
    public var height;
    public var centerX;
    public var contentX;
    public var contentWidth;
    public var isRound;

    public function initialize(width, height) {
        self.width = width;
        self.height = height;
        centerX = width / 2;
        isRound = (width == height);
        contentWidth = isRound ? ((width * 78) / 100) : (width - 32);
        contentX = (width - contentWidth) / 2;
    }

    public function y(roundValue, rectangleValue) {
        return isRound ? roundValue : rectangleValue;
    }
}
