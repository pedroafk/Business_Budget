import 'package:business_budget/lib/models/products/product.dart';

abstract class BusinessRule {
  bool apply(Product product);
  BusinessRule();
}

class PricingRule extends BusinessRule {
  final double discount;

  PricingRule(this.discount);

  @override
  bool apply(Product product) {
    return product.price > 1000;
  }
}

class ValidationRule extends BusinessRule {
  @override
  bool apply(Product product) {
    return product.name.isNotEmpty;
  }
}

class VisibilityRule extends BusinessRule {
  @override
  bool apply(Product product) {
    return product.price > 0;
  }
}
