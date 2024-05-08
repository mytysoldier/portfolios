import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.size = const Size(double.infinity, double.infinity),
  });

  final String title;
  final Size size;

  @override
  Widget build(Object context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(title),
      style: ElevatedButton.styleFrom(shape: CircleBorder(), fixedSize: size),
    );
  }
}
