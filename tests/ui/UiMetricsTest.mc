import Toybox.Test;

(:test)
function testRoundUiMetricsUseCenteredSafeArea(logger) {
    var metrics = new UiMetrics(280, 280);

    Test.assert(metrics.isRound);
    Test.assertEqual(metrics.centerX, 140);
    Test.assertEqual(metrics.safeTop, 14);
    Test.assertEqual(metrics.safeBottom, 266);
    Test.assertEqual(metrics.contentX, 31);
    Test.assertEqual(metrics.contentWidth, 218);
    Test.assert(metrics.contains(metrics.contentX, metrics.safeTop, metrics.contentWidth, metrics.safeBottom - metrics.safeTop));
    Test.assert(!metrics.contains(0, metrics.safeTop, metrics.contentWidth, 20));
    return true;
}

(:test)
function testRectangleUiMetricsUseSixteenPixelGutters(logger) {
    var metrics = new UiMetrics(282, 470);

    Test.assert(!metrics.isRound);
    Test.assertEqual(metrics.centerX, 141);
    Test.assertEqual(metrics.safeTop, 16);
    Test.assertEqual(metrics.safeBottom, 454);
    Test.assertEqual(metrics.contentX, 16);
    Test.assertEqual(metrics.contentWidth, 250);
    Test.assert(metrics.contains(metrics.contentX, metrics.safeTop, metrics.contentWidth, metrics.safeBottom - metrics.safeTop));
    Test.assert(!metrics.contains(metrics.contentX, 455, 10, 10));
    return true;
}

(:test)
function testUiMetricsResolveShapeOffsetsFromSafeEdges(logger) {
    var roundMetrics = new UiMetrics(280, 280);
    var rectangleMetrics = new UiMetrics(282, 470);

    Test.assertEqual(roundMetrics.top(4, 38), 18);
    Test.assertEqual(rectangleMetrics.top(4, 38), 54);
    Test.assertEqual(roundMetrics.bottom(58, 124), 208);
    Test.assertEqual(rectangleMetrics.bottom(58, 124), 330);
    return true;
}
