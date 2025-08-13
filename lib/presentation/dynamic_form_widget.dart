import 'package:flutter/material.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:business_budget/models/rules/business_rule.dart';
import 'package:business_budget/controllers/quote_controller.dart';

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

  // Mantém o estado local para evitar problemas de reconstrução
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
    // Calcula localmente em vez de usar o BLoC para evitar loops
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

    // Coleta todos os valores dos campos
    Map<String, String> allFields = {};
    for (var field in widget.fields) {
      allFields[field.label] = controllers[field.label]?.text ?? '';
    }

    // Calcula o produto e aplica regras localmente
    final product = quoteController.buildProduct(
      widget.productType,
      controllers,
      name: allFields["Nome do Produto"] ?? '',
      price: double.tryParse(allFields["Preço"] ?? '') ?? 0.0,
      quantity: int.tryParse(allFields["Quantidade"] ?? '') ?? 0,
      deadline: int.tryParse(allFields["Prazo (dias)"] ?? '') ?? 0,
    );

    final validationRule = ValidationRule();
    final newCertificationMessage = validationRule.getCertificationMessage(
      product,
    );

    final pricingRule = PricingRule();
    final newFinalPrice = pricingRule.calculateFinalPrice(product);

    setState(() {
      certificationMessage = newCertificationMessage;
      finalPrice = newFinalPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção de campos
          const Text(
            "Preencha os dados do produto",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 20),

          // Campos do formulário
          ...widget.fields.map((field) {
            final controller = controllers[field.label];
            if (field is TextFieldModel || field is NumberFieldModel) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: field.label,
                    labelStyle: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      _getIconForField(field.label),
                      color: const Color(0xFF2E7D32),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF2E7D32),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: field is NumberFieldModel
                      ? TextInputType.number
                      : TextInputType.text,
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          const SizedBox(height: 32),

          // Resultados
          if (certificationMessage.isNotEmpty || finalPrice != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calculate,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Resultado do Orçamento",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  if (certificationMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              certificationMessage,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (finalPrice != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Valor Total:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          Text(
                            "R\$ ${finalPrice!.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  IconData _getIconForField(String label) {
    if (label.toLowerCase().contains('nome')) {
      return Icons.label;
    }
    if (label.toLowerCase().contains('preço') ||
        label.toLowerCase().contains('price')) {
      return Icons.attach_money;
    }
    if (label.toLowerCase().contains('quantidade')) {
      return Icons.inventory;
    }
    if (label.toLowerCase().contains('prazo') ||
        label.toLowerCase().contains('dias')) {
      return Icons.schedule;
    }
    if (label.toLowerCase().contains('voltagem') ||
        label.toLowerCase().contains('voltage')) {
      return Icons.electrical_services;
    }
    if (label.toLowerCase().contains('capacidade') ||
        label.toLowerCase().contains('capacity')) {
      return Icons.battery_charging_full;
    }
    if (label.toLowerCase().contains('categoria') ||
        label.toLowerCase().contains('category')) {
      return Icons.category;
    }
    if (label.toLowerCase().contains('área') ||
        label.toLowerCase().contains('area')) {
      return Icons.square_foot;
    }
    if (label.toLowerCase().contains('funcionários') ||
        label.toLowerCase().contains('employees')) {
      return Icons.people;
    }
    return Icons.edit;
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
