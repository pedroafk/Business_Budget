import 'package:flutter/material.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:business_budget/models/products/product.dart';
import 'package:business_budget/models/rules/business_rule.dart';

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

    final name = controllers["Nome do Produto"]?.text ?? '';
    final price = double.tryParse(controllers["Preço"]?.text ?? '') ?? 0.0;
    final quantity = int.tryParse(controllers["Quantidade"]?.text ?? '') ?? 0;
    final deadline = int.tryParse(controllers["Prazo (dias)"]?.text ?? '') ?? 0;

    Product product;
    if (widget.productType == "Industrial") {
      final voltage = int.tryParse(controllers["Voltagem"]?.text ?? '') ?? 0;
      final certification = controllers["Certificação"]?.text ?? '';
      final industrialCapacity =
          int.tryParse(controllers["Capacidade Industrial"]?.text ?? '') ?? 0;
      product = IndustrialProduct(
        name,
        price,
        quantity,
        deadline,
        voltage: voltage,
        certification: certification,
        industrialCapacity: industrialCapacity,
      );
    } else if (widget.productType == "Residential") {
      final color = controllers["Cor"]?.text ?? '';
      final guarantee = controllers["Garantia"]?.text ?? '';
      final finishing = controllers["Acabamento"]?.text ?? '';
      product = ResidentialProduct(
        name,
        price,
        quantity,
        deadline,
        color: color,
        guarantee: guarantee,
        finishing: finishing,
      );
    } else if (widget.productType == "Corporate") {
      final corporateVolume =
          int.tryParse(controllers["Volume Corporativo"]?.text ?? '') ?? 0;
      final contract = controllers["Contrato"]?.text ?? '';
      final sla = controllers["SLA"]?.text ?? '';
      product = CorporateProduct(
        name,
        price,
        quantity,
        deadline,
        corporateVolume: corporateVolume,
        contract: contract,
        sla: sla,
      );
    } else {
      product = GenericProduct(name, price, quantity, deadline);
    }

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
