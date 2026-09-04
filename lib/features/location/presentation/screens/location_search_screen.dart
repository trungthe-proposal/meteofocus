import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/location_search_panel.dart';

class LocationSearchScreen extends StatelessWidget {
  const LocationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LocationSearchPanel(onCitySelected: () => context.go('/')),
      ),
    );
  }
}
