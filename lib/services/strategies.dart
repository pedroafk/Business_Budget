// Strategy Patterns conforme requisitos técnicos
import '../models/products/product.dart';
import '../utils/mixin.dart';

/// Interface para estratégias de preço
abstract class IPricingStrategy {
  double calculatePrice(Product product);
  String getDescription();
  int get priority;
}

/// Interface para estratégias de validação
abstract class IValidationStrategy {
  bool validate(Product product);
  String getValidationMessage(Product product);
  List<String> getRequiredFields();
}

/// Interface para estratégias de renderização
abstract class IRenderingStrategy {
  Map<String, dynamic> getFieldConfiguration(String productType);
  List<String> getVisibleFields(String productType);
  Map<String, String> getFieldLabels(String productType);
}

/// === IMPLEMENTAÇÕES DE PRICING STRATEGIES ===

/// Estratégia de desconto por volume (≥50 unidades = 15%)
class VolumeDiscountStrategy extends IPricingStrategy with CalculatorMixin {
  @override
  double calculatePrice(Product product) {
    final basePrice = product.price * product.quantity;
    final discount = calculateVolumeDiscount(product.quantity, product.price);
    return basePrice - discount;
  }

  @override
  String getDescription() {
    return "Desconto de 15% para pedidos com 50+ unidades";
  }

  @override
  int get priority => 1;
}

/// Estratégia de taxa de urgência (<7 dias = +20%)
class UrgencyFeeStrategy extends IPricingStrategy with CalculatorMixin {
  @override
  double calculatePrice(Product product) {
    final basePrice = product.price * product.quantity;
    final urgencyFee = calculateUrgencyFee(product.deadline, product.price);
    return basePrice + urgencyFee;
  }

  @override
  String getDescription() {
    return "Taxa de urgência de 20% para prazos menores que 7 dias";
  }

  @override
  int get priority => 2;
}

/// Estratégia de preço base
class BaseStrategy extends IPricingStrategy {
  @override
  double calculatePrice(Product product) {
    return product.price * product.quantity;
  }

  @override
  String getDescription() {
    return "Preço base do produto";
  }

  @override
  int get priority => 0;
}

/// Estratégia de preço industrial (com certificação)
class IndustrialPricingStrategy extends IPricingStrategy {
  @override
  double calculatePrice(Product product) {
    if (product is IndustrialProduct) {
      double basePrice = product.price * product.quantity;

      // Taxa adicional para alta voltagem
      if (product.voltage > 220) {
        basePrice *= 1.1; // 10% adicional
      }

      // Taxa adicional para capacidade industrial alta
      if (product.industrialCapacity > 1000) {
        basePrice *= 1.05; // 5% adicional
      }

      return basePrice;
    }
    return product.price * product.quantity;
  }

  @override
  String getDescription() {
    return "Preço industrial com taxas por voltagem e capacidade";
  }

  @override
  int get priority => 3;
}

/// === IMPLEMENTAÇÕES DE VALIDATION STRATEGIES ===

/// Estratégia de validação para produtos industriais
class IndustrialValidationStrategy extends IValidationStrategy
    with ValidatorMixin {
  @override
  bool validate(Product product) {
    if (product is! IndustrialProduct) return false;

    // Certificação obrigatória para voltagem >220V
    if (product.voltage > 220 && !isRequired(product.certification)) {
      return false;
    }

    // Validações básicas
    return isRequired(product.name) &&
        isPositive(product.price) &&
        isPositive(product.quantity.toDouble()) &&
        isPositive(product.deadline.toDouble()) &&
        product.voltage > 0 &&
        product.industrialCapacity > 0;
  }

  @override
  String getValidationMessage(Product product) {
    if (product is! IndustrialProduct) {
      return "Produto deve ser do tipo Industrial";
    }

    if (product.voltage > 220 && !isRequired(product.certification)) {
      return "Certificação obrigatória para equipamentos com voltagem superior a 220V";
    }

    if (!validate(product)) {
      return "Todos os campos obrigatórios devem ser preenchidos corretamente";
    }

    return "";
  }

  @override
  List<String> getRequiredFields() {
    return [
      'Nome do Produto',
      'Preço',
      'Quantidade',
      'Prazo (dias)',
      'Voltagem',
      'Certificação',
      'Capacidade Industrial',
    ];
  }
}

/// Estratégia de validação para produtos residenciais
class ResidentialValidationStrategy extends IValidationStrategy
    with ValidatorMixin {
  @override
  bool validate(Product product) {
    if (product is! ResidentialProduct) return false;

    return isRequired(product.name) &&
        isPositive(product.price) &&
        isPositive(product.quantity.toDouble()) &&
        isPositive(product.deadline.toDouble()) &&
        isRequired(product.color) &&
        isRequired(product.guarantee) &&
        isRequired(product.finishing);
  }

  @override
  String getValidationMessage(Product product) {
    if (product is! ResidentialProduct) {
      return "Produto deve ser do tipo Residencial";
    }

    if (!validate(product)) {
      return "Todos os campos obrigatórios devem ser preenchidos";
    }

    return "";
  }

  @override
  List<String> getRequiredFields() {
    return [
      'Nome do Produto',
      'Preço',
      'Quantidade',
      'Prazo (dias)',
      'Cor',
      'Garantia',
      'Acabamento',
    ];
  }
}

/// Estratégia de validação para produtos corporativos
class CorporateValidationStrategy extends IValidationStrategy
    with ValidatorMixin {
  @override
  bool validate(Product product) {
    if (product is! CorporateProduct) return false;

    return isRequired(product.name) &&
        isPositive(product.price) &&
        isPositive(product.quantity.toDouble()) &&
        isPositive(product.deadline.toDouble()) &&
        product.corporateVolume > 0 &&
        isRequired(product.contract) &&
        isRequired(product.sla);
  }

  @override
  String getValidationMessage(Product product) {
    if (product is! CorporateProduct) {
      return "Produto deve ser do tipo Corporativo";
    }

    if (!validate(product)) {
      return "Todos os campos obrigatórios devem ser preenchidos";
    }

    return "";
  }

  @override
  List<String> getRequiredFields() {
    return [
      'Nome do Produto',
      'Preço',
      'Quantidade',
      'Prazo (dias)',
      'Volume Corporativo',
      'Contrato',
      'SLA',
    ];
  }
}

/// === IMPLEMENTAÇÕES DE RENDERING STRATEGIES ===

/// Estratégia de renderização para produtos industriais
class IndustrialRenderingStrategy extends IRenderingStrategy {
  @override
  Map<String, dynamic> getFieldConfiguration(String productType) {
    if (productType != 'Industrial') return {};

    return {
      'Voltagem': {'type': 'number', 'required': true, 'min': 1, 'max': 500},
      'Certificação': {'type': 'text', 'required': true, 'maxLength': 50},
      'Capacidade Industrial': {'type': 'number', 'required': true, 'min': 1},
    };
  }

  @override
  List<String> getVisibleFields(String productType) {
    if (productType != 'Industrial') return [];

    return [
      'Nome do Produto',
      'Preço',
      'Quantidade',
      'Prazo (dias)',
      'Voltagem',
      'Certificação',
      'Capacidade Industrial',
    ];
  }

  @override
  Map<String, String> getFieldLabels(String productType) {
    if (productType != 'Industrial') return {};

    return {
      'Voltagem': 'Voltagem (V)',
      'Certificação': 'Certificação Industrial',
      'Capacidade Industrial': 'Capacidade (unidades/h)',
    };
  }
}

/// Estratégia de renderização para produtos residenciais
class ResidentialRenderingStrategy extends IRenderingStrategy {
  @override
  Map<String, dynamic> getFieldConfiguration(String productType) {
    if (productType != 'Residential') return {};

    return {
      'Cor': {
        'type': 'text',
        'required': true,
        'options': ['Branco', 'Preto', 'Prata', 'Dourado'],
      },
      'Garantia': {'type': 'text', 'required': true, 'maxLength': 30},
      'Acabamento': {
        'type': 'text',
        'required': true,
        'options': ['Fosco', 'Brilhante', 'Acetinado'],
      },
    };
  }

  @override
  List<String> getVisibleFields(String productType) {
    if (productType != 'Residential') return [];

    return [
      'Nome do Produto',
      'Preço',
      'Quantidade',
      'Prazo (dias)',
      'Cor',
      'Garantia',
      'Acabamento',
    ];
  }

  @override
  Map<String, String> getFieldLabels(String productType) {
    if (productType != 'Residential') return {};

    return {
      'Cor': 'Cor do Produto',
      'Garantia': 'Período de Garantia',
      'Acabamento': 'Tipo de Acabamento',
    };
  }
}

/// Estratégia de renderização para produtos corporativos
class CorporateRenderingStrategy extends IRenderingStrategy {
  @override
  Map<String, dynamic> getFieldConfiguration(String productType) {
    if (productType != 'Corporate') return {};

    return {
      'Volume Corporativo': {'type': 'number', 'required': true, 'min': 100},
      'Contrato': {
        'type': 'text',
        'required': true,
        'options': ['Mensal', 'Anual', 'Plurianual'],
      },
      'SLA': {
        'type': 'text',
        'required': true,
        'options': ['24h', '48h', '72h', '7 dias'],
      },
    };
  }

  @override
  List<String> getVisibleFields(String productType) {
    if (productType != 'Corporate') return [];

    return [
      'Nome do Produto',
      'Preço',
      'Quantidade',
      'Prazo (dias)',
      'Volume Corporativo',
      'Contrato',
      'SLA',
    ];
  }

  @override
  Map<String, String> getFieldLabels(String productType) {
    if (productType != 'Corporate') return {};

    return {
      'Volume Corporativo': 'Volume Mínimo (unidades)',
      'Contrato': 'Tipo de Contrato',
      'SLA': 'Tempo de Resposta (SLA)',
    };
  }
}
