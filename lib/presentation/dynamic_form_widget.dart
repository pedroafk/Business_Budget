import 'package:flutter/material.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:business_budget/models/rules/business_rule.dart';
import 'package:business_budget/controllers/quote_controller.dart';
import 'package:business_budget/utils/extension.dart';

class DynamicFormWidget extends StatefulWidget {
  final List<FormFieldModel> fields;
  final String productType;

  const DynamicFormWidget({
    required this.fields,
    required this.productType,
    super.key,
  });

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  final Map<String, TextEditingController> controllers = {};
  final QuoteController quoteController = QuoteController();
  String certificationMessage = "";
  double? finalPrice;

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
      controllers[field.label]!.removeListener(_calculateResult);
      controllers[field.label]!.addListener(_calculateResult);
    }
    _calculateResult();
  }

  void _initControllers(List<FormFieldModel> fields) {
    for (var field in fields) {
      controllers[field.label] = TextEditingController();
      controllers[field.label]!.addListener(_calculateResult);
    }
  }

  void _calculateResult() {
    final allFilled = widget.fields.every((field) {
      final value = controllers[field.label]?.text ?? '';
      return value.isNotEmpty;
    });
    if (!allFilled) {
      setState(() {
        certificationMessage = "";
        finalPrice = null;
      });
      return;
    }

    // Use StringExtensions para conversão segura
    final name = controllers["Nome do Produto"]?.text ?? '';
    final price = StringExtensions().toDouble(controllers["Preço"]?.text ?? '');
    final quantity = StringExtensions().toInt(
      controllers["Quantidade"]?.text ?? '',
    );
    final deadline = StringExtensions().toInt(
      controllers["Prazo (dias)"]?.text ?? '',
    );

    // Use o QuoteController para montar o produto
    final product = quoteController.buildProduct(
      widget.productType,
      controllers,
      name: name,
      price: price,
      quantity: quantity,
      deadline: deadline,
    );

    final validationRule = ValidationRule();
    certificationMessage = validationRule.getCertificationMessage(product);

    final pricingRule = PricingRule();
    finalPrice = pricingRule.calculateFinalPrice(product);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.fields.map((field) {
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
        }),
        const SizedBox(height: 24),
        if (certificationMessage.isNotEmpty)
          Text(
            certificationMessage,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (finalPrice != null)
          Text(
            "Orçamento final: R\$ ${finalPrice!.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      ],
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
