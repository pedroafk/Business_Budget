import 'package:business_budget/models/products/product.dart';

abstract class BusinessRule {
  bool apply(Product product);
  BusinessRule();
}

class PricingRule extends BusinessRule {
  @override
  bool apply(Product product) {
    return product.quantity >= 50 || product.deadline < 7;
  }

  double getDiscountedPrice(Product product) {
    return product.discountedPrice;
  }
}

class ValidationRule extends BusinessRule {
  @override
  bool apply(Product product) {
    throw UnimplementedError();
  }
}

class VisibilityRule extends BusinessRule {
  @override
  bool apply(Product product) {
    throw UnimplementedError();
  }
}
