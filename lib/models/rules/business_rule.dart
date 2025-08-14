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
    double basePrice = product.price * product.quantity;
    double finalPrice = basePrice;

    if (product.quantity >= 50) {
      finalPrice *= 0.85;
    }

    if (product.deadline < 7) {
      finalPrice *= 1.20;
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
    List<FormFieldModel> fields = [
      TextFieldModel("Nome do Produto"),
      DoubleFieldModel("Preço"),
      IntFieldModel("Quantidade"),
      IntFieldModel("Prazo (dias)"),
    ];

    switch (productType) {
      case "Corporate":
        fields.addAll([
          TextFieldModel("Volume Corporativo"),
          TextFieldModel("Contrato"),
          TextFieldModel("SLA"),
        ]);
        break;
      case "Residential":
        fields.addAll([
          TextFieldModel("Cor"),
          TextFieldModel("Garantia"),
          TextFieldModel("Acabamento"),
        ]);
        break;
      case "Industrial":
        fields.addAll([
          DoubleFieldModel("Voltagem"),
          TextFieldModel("Certificação"),
          TextFieldModel("Capacidade Industrial"),
        ]);
        break;
      default:
        break;
    }
    return fields;
  }
}
