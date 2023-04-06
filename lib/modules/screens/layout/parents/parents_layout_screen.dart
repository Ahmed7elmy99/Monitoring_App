import 'package:flutter/material.dart';

class ParentLayoutScreen extends StatelessWidget {
  const ParentLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Layout'),
      ),
      body: const Center(
        child: Text('Parent Layout'),
      ),
    );
  }
}
