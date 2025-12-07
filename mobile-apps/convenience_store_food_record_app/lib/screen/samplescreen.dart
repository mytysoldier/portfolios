import 'package:flutter/material.dart';

class PasswordTextFieldSample extends StatefulWidget {
  const PasswordTextFieldSample({super.key});

  @override
  State<PasswordTextFieldSample> createState() =>
      _PasswordTextFieldSampleState();
}

class _PasswordTextFieldSampleState extends State<PasswordTextFieldSample> {
  bool _obscureText = true; // 初期状態はパスワードを隠す

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password TextField Sample')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _toggleVisibility,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
