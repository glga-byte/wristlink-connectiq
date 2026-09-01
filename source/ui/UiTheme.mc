import Toybox.Graphics;

module UiTheme {
    const DARK_BACKGROUND = 0x101112;
    const DARK_SURFACE = 0x1B1C1D;
    const LIGHT_BACKGROUND = 0xF4F4EF;
    const LIGHT_SURFACE = 0xFFFFFF;
    const ACCENT = 0xFFD43B;
    const TEAL = 0x2F969B;
    const INK = 0x101112;
    const MUTED_DARK = 0xB9B9B5;
    const MUTED_LIGHT = 0x6D706C;
    const BORDER_DARK = 0x4D4E4E;
    const BORDER_LIGHT = 0xD5D6D1;

    function background(isDark) {
        return isDark ? DARK_BACKGROUND : LIGHT_BACKGROUND;
    }

    function foreground(isDark) {
        return isDark ? Graphics.COLOR_WHITE : INK;
    }

    function muted(isDark) {
        return isDark ? MUTED_DARK : MUTED_LIGHT;
    }
}
