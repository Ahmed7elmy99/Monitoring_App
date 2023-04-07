import 'package:flutter/material.dart';

class SchoolsSettingsScreen extends StatelessWidget {
  const SchoolsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Schools Settings Screen',
          style: Theme.of(context).textTheme.headline6,
        ),
        Placeholder(),
      ],
    );
  }
}
