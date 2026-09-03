import 'package:flutter/material.dart';

/// Shadow mềm cho card lớn: CSS gốc `0 10-16px 26-34px rgba(15,44,71,.5-.6)`.
/// TODO: đối chiếu lại trực quan với `MeteoFocus.dc.html` khi ghép UI thật (Buổi 4) —
/// Flutter render blur khác CSS nên giá trị dưới đây chỉ là điểm khởi đầu gần đúng.
abstract final class AppShadows {
  static const card = [
    BoxShadow(
      color: Color(0x330F2C47),
      blurRadius: 30,
      offset: Offset(0, 13),
    ),
  ];
}
