import 'package:flutter/material.dart';

class CenterMenu extends StatelessWidget {
  final String imagePath;
  final List<Widget> buttons;

  const CenterMenu({super.key, required this.imagePath, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 180, fit: BoxFit.contain),
            const SizedBox(height: 30),
            ...buttons.map(
              (b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: b,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
