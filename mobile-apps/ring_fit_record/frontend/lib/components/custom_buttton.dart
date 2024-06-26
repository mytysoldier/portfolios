import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.size = const Size(double.infinity, double.infinity),
    required this.onButtonPressed,
  });

  final String title;
  final Size size;
  final VoidCallback onButtonPressed;

  @override
  Widget build(Object context) {
    return ElevatedButton(
      onPressed: () {
        onButtonPressed();
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        fixedSize: size,
        backgroundColor: Colors.brown,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
