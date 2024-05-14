import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isExpanded = false,
  });

  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: isExpanded,
      items: items
          .map<DropdownMenuItem<String>>(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          )
          .toList(),
      value: value,
      onChanged: onChanged,
    );
  }
}
