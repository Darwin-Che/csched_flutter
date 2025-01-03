import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
