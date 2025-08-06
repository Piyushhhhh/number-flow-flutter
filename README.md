# Flutter Number Flow

A Flutter widget that animates number changes with smooth, customizable transitions. Perfect for displaying animated counters, currency values, statistics, and more.

[![pub package](https://img.shields.io/pub/v/flutter_number_flow.svg)](https://pub.dev/packages/flutter_number_flow)
[![pub points](https://img.shields.io/pub/points/flutter_number_flow)](https://pub.dev/packages/flutter_number_flow/score)
[![popularity](https://img.shields.io/pub/popularity/flutter_number_flow)](https://pub.dev/packages/flutter_number_flow/score)
[![likes](https://img.shields.io/pub/likes/flutter_number_flow)](https://pub.dev/packages/flutter_number_flow/score)

## Features

- 🎯 **Multiple Animation Styles**: slide, spin, and crossFade animations
- 🌍 **Locale-Aware Formatting**: Support for different locales, currencies, and number formats
- 📊 **Compact Notation**: Automatic formatting for large numbers (K, M, B)
- 🔄 **Group Synchronization**: Animate multiple NumberFlow widgets in perfect sync
- 🎛️ **Manual Control**: Scrub through animations with timeline control
- ⚡ **Performance Optimized**: Text metrics caching and tabular figures for stability
- ♿ **Accessibility**: Built-in semantics support
- 🎨 **Customizable**: Full control over styling, duration, curves, and alignment

## Quick Start

Add NumberFlow to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_number_flow: ^0.1.0
```

## Basic Usage

```dart
import 'package:flutter_number_flow/number_flow.dart';

NumberFlow(
  value: 1234.56,
  textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
)
```

## Advanced Usage

### Currency Formatting

```dart
NumberFlow(
  value: 1234.56,
  previousValue: 1000.00,
  format: NumberFlowFormat(
    prefix: '\$',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  ),
  animationStyle: NumberFlowAnimation.slide,
  duration: Duration(milliseconds: 800),
)
```

### Compact Notation

```dart
NumberFlow(
  value: 1234567,
  format: NumberFlowFormat(
    notation: NumberNotation.compact,
  ),
  // Displays as "1.2M"
)
```

### Group Synchronization

```dart
NumberFlowGroupProvider(
  groupKey: 'dashboard',
  child: Column(
    children: [
      NumberFlow(value: revenue, groupKey: 'dashboard'),
      NumberFlow(value: expenses, groupKey: 'dashboard'),
      NumberFlow(value: profit, groupKey: 'dashboard'),
    ],
  ),
)
```

### Manual Timeline Control

```dart
NumberFlow(
  value: endValue,
  previousValue: startValue,
  scrubProgress: sliderValue, // 0.0 to 1.0
)
```

## API Reference

### NumberFlow Widget

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | `num` | required | Current number value |
| `previousValue` | `num?` | null | Previous value for animation |
| `textStyle` | `TextStyle?` | null | Text styling |
| `duration` | `Duration` | 600ms | Animation duration |
| `curve` | `Curve` | easeInOut | Animation curve |
| `animationStyle` | `NumberFlowAnimation` | slide | Animation type |
| `format` | `NumberFlowFormat?` | null | Number formatting |
| `textAlign` | `TextAlign` | center | Text alignment |
| `groupKey` | `String?` | null | Group synchronization key |
| `scrubProgress` | `double?` | null | Manual progress (0-1) |
| `enableMask` | `bool` | true | Enable edge masking |

### NumberFlowAnimation Enum

- `NumberFlowAnimation.slide` - Slide animation (default)
- `NumberFlowAnimation.spin` - 3D spin animation  
- `NumberFlowAnimation.crossFade` - Cross-fade animation

### NumberFlowFormat Class

```dart
NumberFlowFormat({
  String? locale,              // e.g., 'en_US', 'de_DE'
  NumberNotation notation,     // standard or compact
  String? prefix,              // e.g., '$', '€'
  String? suffix,              // e.g., '%', '°C'
  int? minimumFractionDigits,  // Min decimal places
  int? maximumFractionDigits,  // Max decimal places
})
```

### NumberFlowGroup

Use `NumberFlowGroupProvider` to create synchronized animation groups:

```dart
NumberFlowGroupProvider(
  groupKey: 'unique-group-id',
  duration: Duration(milliseconds: 800),
  curve: Curves.easeInOut,
  child: YourWidget(),
)
```

## Examples

The package includes a comprehensive example app demonstrating:

1. **Basics**: Fundamental animations and styles
2. **Decimals**: Temperature monitors and stock prices
3. **Compact**: Social media followers and download counters
4. **Group Sync**: Financial dashboard with synchronized updates
5. **Scrub Timeline**: Manual animation control

Run the example:

```bash
cd example
flutter run
```

## Performance

NumberFlow is optimized for smooth animations:

- **Text Metrics Caching**: Avoids repeated TextPainter measurements
- **Tabular Figures**: Uses monospace digits for consistent width
- **Minimal Rebuilds**: Only animates changed characters
- **Hardware Acceleration**: Leverages GPU for smooth animations

## Accessibility

NumberFlow includes built-in accessibility support:

- Semantic labels for screen readers
- Proper focus management
- High contrast support
- Reduced motion respect

## Contributing

We welcome contributions! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.