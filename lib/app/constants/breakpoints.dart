/// Breakpoint theo `ARCHITECTURE.md §6`.
enum LayoutSize { compact, medium, expanded }

abstract final class AppBreakpoints {
  static const compactMax = 600.0;
  static const mediumMax = 840.0;
}

LayoutSize layoutSizeOf(double width) {
  if (width < AppBreakpoints.compactMax) return LayoutSize.compact;
  if (width < AppBreakpoints.mediumMax) return LayoutSize.medium;
  return LayoutSize.expanded;
}
