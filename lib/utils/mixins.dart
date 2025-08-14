import '../models/products/product.dart';

mixin ValidatorMixin {
  bool isInRange(double value, double min, double max) =>
      value >= min && value <= max;
  bool isRequired(String? value) => value != null && value.trim().isNotEmpty;
  bool isPositive(double value) => value > 0;
}

mixin CalculatorMixin {
  double calculateVolumeDiscount(int quantity, double basePrice) {
    if (quantity >= 50) return basePrice * 0.15;
    return 0.0;
  }

  double calculateUrgencyFee(int deadline, double basePrice) {
    if (deadline < 7) return basePrice * 0.20;
    return 0.0;
  }

  double calculateFinalPrice({
    required double basePrice,
    required int quantity,
    required int deadline,
    double additionalFees = 0.0,
  }) {
    final volumeDiscount = calculateVolumeDiscount(quantity, basePrice);
    final urgencyFee = calculateUrgencyFee(deadline, basePrice);
    return (basePrice * quantity) -
        volumeDiscount +
        urgencyFee +
        additionalFees;
  }
}

mixin FormatterMixin {
  String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String formatNumber(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }
}

extension ProductExtensions on Product {
  bool get needsCertification {
    if (this is IndustrialProduct) {
      final industrial = this as IndustrialProduct;
      return industrial.voltage > 220;
    }
    return false;
  }

  bool get hasVolumeDiscount => quantity >= 50;
  bool get isHighPriority => deadline < 7;
}

extension StringExtensions on String {
  double toDoubleValue() => double.tryParse(replaceAll(',', '.')) ?? 0.0;
  int toIntValue() => int.tryParse(this) ?? 0;
  bool get isNumeric => double.tryParse(replaceAll(',', '.')) != null;
}
