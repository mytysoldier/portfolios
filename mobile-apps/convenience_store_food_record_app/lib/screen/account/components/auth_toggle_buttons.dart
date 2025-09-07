import 'package:flutter/material.dart';

class AuthToggleButtons extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  const AuthToggleButtons({
    Key? key,
    required this.selectedIndex,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [selectedIndex == 0, selectedIndex == 1],
      onPressed: onChanged,
      borderRadius: BorderRadius.circular(8),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('ログイン'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('新規登録'),
        ),
      ],
    );
  }
}
