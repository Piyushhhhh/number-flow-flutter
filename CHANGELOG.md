# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-11-23

### Fixed
- Removed glyphs now shrink and fade out instead of remaining on screen (#1, #2)
- Inserted glyphs animate into the layout without an abrupt width jump
- `scrubProgress` now directly drives manual transitions
- Grouped widgets now use their shared controller and provider curve
- Completed grouped widgets no longer replay stale transitions
- `previousValue` now animates on the initial build
- Formatter options are honored during lazy initialization
- Character diffing now handles Unicode grapheme clusters safely

### Changed
- Added behavioral coverage for deletion, insertion, scrubbing, and groups
- Corrected package documentation and repository links
- Raised the minimum Dart SDK to 3.0 to match `intl` 0.19

## [0.1.0] - 2024-01-15

### Added
- Initial release of Flutter Number Flow
- `NumberFlow` widget with smooth number animations
- Two animation styles: `slide` and `crossFade`
- Locale-aware number formatting using `intl` package
- Support for currency formatting with prefix/suffix
- Compact notation for large numbers (K, M, B)
- Group synchronization for multiple NumberFlow widgets
- Manual animation control with scrub progress
- Edge masking for smooth visual clipping
- Performance optimizations with text metrics caching
- Accessibility support with proper semantics
- Material Design 3 theme support
- Comprehensive example app with 5 demo screens
- Unit and widget test coverage
- Complete API documentation

### Features
- **Animation Styles**: Smooth slide and crossfade animations
- **Formatting**: Locale-aware formatting with decimal control
- **Performance**: Optimized with caching and tabular figures
- **Accessibility**: Screen reader support and proper semantics
- **Customization**: Full control over styling and behavior
- **Group Sync**: Coordinate animations across multiple widgets
- **Manual Control**: Drive animations with external progress
- **i18n Support**: Internationalization with locale formatting

### Technical Details
- Minimum Flutter version: 3.0.0
- Minimum Dart SDK: 3.0.0
- Dependencies: `characters`, `flutter`, `intl`
- Platform support: iOS, Android, Web, Desktop
- Null safety: Full null safety support
- Material 3: Built with Material Design 3 principles

### Documentation
- Comprehensive README with examples
- API documentation for all public classes
- Example app demonstrating all features
- Migration guide and best practices
- Contributing guidelines

### Testing
- Unit tests for core functionality
- Widget tests for UI components

---

## Upcoming Features (Roadmap)

### [0.2.0] - Planned
- **New Animation Styles**: Bounce, elastic, and scale animations
- **Enhanced Formatting**: Custom number patterns and separators
- **Theme Integration**: Better Material 3 and Cupertino theme support
- **Performance**: Further optimizations for large datasets
- **Accessibility**: Enhanced VoiceOver and TalkBack support

### [0.3.0] - Planned
- **Chart Integration**: Built-in chart and graph animations
- **Gesture Support**: Touch-based scrubbing and interaction
- **Sound Effects**: Optional audio feedback for animations
- **Advanced Layouts**: Grid and list-based number displays
- **Web Optimizations**: Enhanced performance for web platform

---

## Migration Guides

### From 0.x.x to 0.1.0
This is the initial release, no migration needed.

---

## Support and Feedback

We welcome feedback and contributions! Please:

- 🐛 [Report bugs](https://github.com/Piyushhhhh/number-flow-flutter/issues)
- 💡 [Request features](https://github.com/Piyushhhhh/number-flow-flutter/discussions)
- 🤝 [Contribute code](https://github.com/Piyushhhhh/number-flow-flutter/pulls)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
