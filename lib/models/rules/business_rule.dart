import 'package:business_budget/models/products/product.dart';
import 'package:business_budget/models/fields/form_field_model.dart';

abstract class BusinessRule {
  bool apply(Product product);
  BusinessRule();
}

class PricingRule extends BusinessRule {
  @override
  bool apply(Product product) {
    return product.quantity >= 50 || product.deadline < 7;
  }

  double calculateFinalPrice(Product product) {
    // Calcula o valor base: preço unitário × quantidade
    double basePrice = product.price * product.quantity;
    double finalPrice = basePrice;

    // Aplica desconto por quantidade (desconto de 15% para pedidos grandes)
    if (product.quantity >= 50) {
      finalPrice *= 0.85; // 15% de desconto
    }

    // Aplica acréscimo por urgência (20% a mais para prazos curtos)
    if (product.deadline < 7) {
      finalPrice *= 1.20; // 20% de acréscimo
    }

    return finalPrice;
  }
}

class ValidationRule extends BusinessRule {
  @override
  bool apply(Product product) {
    if (product is IndustrialProduct && product.voltage > 220) {
      return true;
    }
    return false;
  }

  String getCertificationMessage(Product product) {
    if (product is IndustrialProduct && product.voltage > 220) {
      return "Certificação Obrigatória";
    }
    return "";
  }
}

class VisibilityRule extends BusinessRule {
  @override
  bool apply(Product product) {
    return false;
  }

  List<FormFieldModel> getFieldsForProductType(String productType) {
    // Campos básicos com tipos corretos
    List<FormFieldModel> fields = [
      TextFieldModel("Nome do Produto"), // string
      DoubleFieldModel("Preço"), // double
      IntFieldModel("Quantidade"), // int
      IntFieldModel("Prazo (dias)"), // int
    ];

    switch (productType) {
      case "Corporate":
        fields.addAll([
          TextFieldModel("Volume Corporativo"), // string
          TextFieldModel("Contrato"), // string
          TextFieldModel("SLA"), // string
        ]);
        break;
      case "Residential":
        fields.addAll([
          TextFieldModel("Cor"), // string
          TextFieldModel("Garantia"), // string
          TextFieldModel("Acabamento"), // string
        ]);
        break;
      case "Industrial":
        fields.addAll([
          DoubleFieldModel("Voltagem"), // double
          TextFieldModel("Certificação"), // string
          TextFieldModel("Capacidade Industrial"), // string
        ]);
        break;
      default:
        break;
    }
    return fields;
  }
}
