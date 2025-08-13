import 'package:flutter/material.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_budget/bloc/business_bloc.dart';

class DynamicFormWidget extends StatefulWidget {
  final List<FormFieldModel> fields;
  const DynamicFormWidget({required this.fields, super.key});

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers(widget.fields);
  }

  @override
  void didUpdateWidget(covariant DynamicFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLabels = oldWidget.fields.map((f) => f.label).toSet();
    final newLabels = widget.fields.map((f) => f.label).toSet();

    for (var label in oldLabels.difference(newLabels)) {
      controllers[label]?.clear();
    }

    for (var field in widget.fields) {
      controllers.putIfAbsent(field.label, () => TextEditingController());
    }
  }

  void _initControllers(List<FormFieldModel> fields) {
    for (var field in fields) {
      controllers[field.label] = TextEditingController();
      controllers[field.label]!.addListener(_checkFields);
    }
  }

  void _checkFields() {
    final allFilled = widget.fields.every((field) {
      final value = controllers[field.label]?.text ?? '';
      return value.isNotEmpty;
    });
    if (allFilled) {
      context.read<BusinessBloc>().add(AllFieldsFilled());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.fields.map((field) {
        final controller = controllers[field.label];
        if (field is TextFieldModel || field is NumberFieldModel) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: field.label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              keyboardType: field is NumberFieldModel
                  ? TextInputType.number
                  : TextInputType.text,
            ),
          );
        }
        return SizedBox.shrink();
      }).toList(),
    );
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
