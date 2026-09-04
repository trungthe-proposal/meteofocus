import 'package:flutter/material.dart';

/// Avatar tròn màu theo mã quốc gia — xem
/// `design_meteofocus/README.md §Location Search`. Không cố bám màu cờ thật,
/// chỉ cần màu phân biệt được ổn định theo `countryCode` (dạng hash-to-color
/// thường gặp khi tạo avatar theo initials).
class CountryAvatar extends StatelessWidget {
  const CountryAvatar({super.key, required this.countryCode});

  final String countryCode;

  static const _palette = [
    Color(0xFF1877D2),
    Color(0xFFE0574C),
    Color(0xFF2E9E6D),
    Color(0xFFB8860B),
    Color(0xFF7C5CBF),
    Color(0xFF3AA0A0),
  ];

  Color get _color =>
      _palette[countryCode.hashCode.abs() % _palette.length];

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: _color,
      child: Text(
        countryCode.isEmpty ? '?' : countryCode,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
