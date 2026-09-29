class ColorPalette {
  final String primary;
  final String secondary;
  final String background;
  final String surface;
  final String text;

  const ColorPalette({
    this.primary = '#0066CC',
    this.secondary = '#00AA66',
    this.background = '#FAFAFA',
    this.surface = '#FFFFFF',
    this.text = '#222222',
  });

  static const ColorPalette defaultLight = ColorPalette();
  static const ColorPalette defaultDark = ColorPalette(
    primary: '#3399FF',
    secondary: '#33CC88',
    background: '#121212',
    surface: '#1E121E',
    text: '#EEEEEE',
  );
}

class DesignTokens {
  final ColorPalette colors;
  final double smallSpacing;
  final double mediumSpacing;
  final double largeSpacing;
  final double borderRadius;

  const DesignTokens({
    this.colors = ColorPalette.defaultLight,
    this.smallSpacing = 8.0,
    this.mediumSpacing = 16.0,
    this.largeSpacing = 24.0,
    this.borderRadius = 8.0,
  });

  static const DesignTokens standard = DesignTokens();
}
