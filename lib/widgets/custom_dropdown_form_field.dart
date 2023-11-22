import 'package:flutter/material.dart';

import '../shared/theme.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?)? onChanged;
  final double radiusBorder;

  const CustomDropdownFormField({
    Key? key,
    required this.hintText,
    required this.items,
    required this.radiusBorder,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null; // Return null if the field is valid
      },
      isExpanded: true,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: greyText,
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBorder),
          borderSide: BorderSide(color: grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBorder),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: greyText,
          ),
        );
      }).toList(),
    );
  }
}
