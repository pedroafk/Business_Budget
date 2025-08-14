import '../models/products/product.dart';

abstract class IPricingStrategy {
  double calculatePrice(Product product);
}

abstract class IValidationStrategy {
  bool validate(Product product);
  String getValidationMessage(Product product);
}

abstract class IRenderingStrategy {
  List<String> getRequiredFields(String productType);
}

class VolumePricingStrategy implements IPricingStrategy {
  @override
  double calculatePrice(Product product) {
    double basePrice = product.price * product.quantity;
    if (product.quantity >= 50) {
      basePrice *= 0.85;
    }
    return basePrice;
  }
}

class UrgencyPricingStrategy implements IPricingStrategy {
  @override
  double calculatePrice(Product product) {
    double basePrice = product.price * product.quantity;
    if (product.deadline < 7) {
      basePrice *= 1.20;
    }
    return basePrice;
  }
}

class IndustrialValidationStrategy implements IValidationStrategy {
  @override
  bool validate(Product product) {
    if (product is IndustrialProduct) {
      return product.voltage > 0 &&
          product.certification.isNotEmpty &&
          product.industrialCapacity > 0;
    }
    return true;
  }

  @override
  String getValidationMessage(Product product) {
    if (product is IndustrialProduct && product.voltage > 220) {
      return "Certificação Obrigatória";
    }
    return "";
  }
}

class ResidentialValidationStrategy implements IValidationStrategy {
  @override
  bool validate(Product product) {
    if (product is ResidentialProduct) {
      return product.color.isNotEmpty &&
          product.guarantee.isNotEmpty &&
          product.finishing.isNotEmpty;
    }
    return true;
  }

  @override
  String getValidationMessage(Product product) => "";
}

class CorporateValidationStrategy implements IValidationStrategy {
  @override
  bool validate(Product product) {
    if (product is CorporateProduct) {
      return product.corporateVolume > 0 &&
          product.contract.isNotEmpty &&
          product.sla.isNotEmpty;
    }
    return true;
  }

  @override
  String getValidationMessage(Product product) => "";
}

class DynamicRenderingStrategy implements IRenderingStrategy {
  @override
  List<String> getRequiredFields(String productType) {
    final baseFields = [
      "Nome do Produto",
      "Preço",
      "Quantidade",
      "Prazo (dias)",
    ];

    switch (productType) {
      case "Industrial":
        return [
          ...baseFields,
          "Voltagem",
          "Certificação",
          "Capacidade Industrial",
        ];
      case "Residential":
        return [...baseFields, "Cor", "Garantia", "Acabamento"];
      case "Corporate":
        return [...baseFields, "Volume Corporativo", "Contrato", "SLA"];
      default:
        return baseFields;
    }
  }
}
