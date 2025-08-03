import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported),
    );
  }
}
