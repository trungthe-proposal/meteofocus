import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/cache/hive_boxes.dart';
import 'core/cache/todo_box_provider.dart';
import 'core/cache/weather_box_provider.dart';
import 'core/prefs/shared_prefs_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('vi_VN');
  final weatherBox = await Hive.openBox(HiveBoxes.weatherCache);
  final todoBox = await Hive.openBox(HiveBoxes.todoItems);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        weatherBoxProvider.overrideWithValue(weatherBox),
        todoBoxProvider.overrideWithValue(todoBox),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MeteoFocusApp(),
    ),
  );
}
