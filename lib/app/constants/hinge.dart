import 'dart:ui';

import 'package:flutter/material.dart';

/// Vị trí bản lề màn hình gập (nếu có) — dùng để layout Medium tránh đặt nội
/// dung đè lên vùng hinge, xem `ARCHITECTURE.md §6`. Máy không phải thiết bị
/// gập (đa số trường hợp: web, phone thường, desktop) trả về `null`.
Rect? hingeBoundsOf(BuildContext context) {
  final features = MediaQuery.of(context).displayFeatures;
  for (final feature in features) {
    final isHinge =
        feature.type == DisplayFeatureType.hinge ||
        feature.type == DisplayFeatureType.fold;
    if (isHinge && feature.bounds.width > 0) {
      return feature.bounds;
    }
  }
  return null;
}
