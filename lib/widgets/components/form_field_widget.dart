import 'package:flutter/material.dart';
import 'package:business_budget/models/fields/form_field_model.dart';

final _border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(color: Colors.grey.shade400),
);

Widget buildFormField(FormFieldModel field) {
  if (field is TextFieldModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: field.label,
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
        ),
      ),
    );
  }
  if (field is NumberFieldModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: field.label,
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
  if (field is SelectFieldModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField(
        items: [],
        onChanged: (_) {},
        decoration: InputDecoration(
          labelText: field.label,
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
        ),
      ),
    );
  }
  return SizedBox.shrink();
}
