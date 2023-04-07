import 'package:flutter/material.dart';

class SchoolsHomeScreen extends StatelessWidget {
  const SchoolsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Schools Home Screen',
          style: Theme.of(context).textTheme.headline6,
        ),
        Placeholder(),
      ],
    );
  }
}
