/// Breakpoint theo `ARCHITECTURE.md §6`.
enum LayoutSize { compact, medium, expanded }

abstract final class AppBreakpoints {
  /// Dưới ngưỡng này coi là Cover Screen (Z Flip đóng) — hiện `MiniWeatherWidget`
  /// thay vì bottom nav 3 tab, vì không đủ chỗ. Xấp xỉ theo màn phụ thực tế
  /// (~260dp) của các máy gập hiện có, chừa dư để không kích hoạt nhầm trên
  /// điện thoại thường (nhỏ nhất phổ biến ~320dp).
  static const coverScreenMax = 300.0;
  static const compactMax = 600.0;
  static const mediumMax = 840.0;
}

LayoutSize layoutSizeOf(double width) {
  if (width < AppBreakpoints.compactMax) return LayoutSize.compact;
  if (width < AppBreakpoints.mediumMax) return LayoutSize.medium;
  return LayoutSize.expanded;
}
