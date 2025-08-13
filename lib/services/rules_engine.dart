import 'package:business_budget/models/products/product.dart';
import 'package:business_budget/models/rules/business_rule.dart';

abstract class RulesEngine<T> {
  void applyRules(T item, List<BusinessRule> rules);
}

// Exemplo para produtos
class ProductRulesEngine extends RulesEngine<Product> {
  @override
  void applyRules(Product product, List<BusinessRule> rules) {
    for (var rule in rules) {
      rule.apply(product);
    }
  }
}
