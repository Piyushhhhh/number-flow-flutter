# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial package structure and API design
- NumberFlow widget with support for multiple animation styles (slide, spin, crossFade)
- NumberFlowFormat class for locale-aware formatting with prefix/suffix support
- NumberFlowGroup InheritedWidget for synchronized animations across multiple widgets
- Core formatter wrapper around intl package
- Character diff algorithm for minimal change detection
- Text metrics cache for performance optimization
- Glyph stack renderer for per-character animations
- Edge masking with ShaderMask and gradient effects
- Comprehensive example app with 5 demonstration screens:
  - Basics: fundamental number animations
  - Decimals: decimal formatting and temperature/price displays
  - Compact: compact notation (K, M, B) for large numbers
  - Group Sync: synchronized animations across multiple widgets
  - Scrub Timeline: manual animation control with timeline scrubbing
- FontFeature.tabularFigures() integration for stable character widths
- Analysis options with pedantic-style linting rules
- MIT License
- Comprehensive README outline structure

### Technical Implementation
- Support for textStyle, duration, curve, align, groupKey, and scrubProgress parameters
- Internal structure with organized source files:
  - `src/core/formatter.dart` - intl package wrapper
  - `src/core/diff.dart` - character run diff with LCS algorithm
  - `src/core/metrics_cache.dart` - TextPainter cache keyed by style+glyph
  - `src/render/glyph_stack.dart` - per-glyph animated presenter
  - `src/render/mask.dart` - ShaderMask/Clip with gradient edges
  - `src/widgets/number_flow.dart` - main widget composition and semantics
  - `src/widgets/number_flow_group.dart` - InheritedWidget for synchronization

### Documentation
- Package-level documentation with comprehensive API coverage
- Example screens demonstrating all major features
- Analysis options for code quality
- Changelog following semantic versioning

## [0.1.0] - TBD

Initial release with skeleton implementation and complete API surface.

### Notes
- This version contains the complete API structure and example implementations
- Core functionality bodies are marked with TODO comments for implementation
- All public APIs are defined and documented
- Example app demonstrates intended usage patterns