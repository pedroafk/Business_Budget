import 'package:flutter/material.dart';
import 'package:business_budget/models/fields/form_field_model.dart';

Widget buildFormField(FormFieldModel field) {
  if (field is TextFieldModel) {
    return TextField(decoration: InputDecoration(labelText: field.label));
  }
  if (field is NumberFieldModel) {
    return TextField(
      decoration: InputDecoration(labelText: field.label),
      keyboardType: TextInputType.number,
    );
  }
  if (field is SelectFieldModel) {
    return DropdownButtonFormField(
      items: [],
      onChanged: (_) {},
      decoration: InputDecoration(labelText: field.label),
    );
  }
  return SizedBox.shrink();
}
