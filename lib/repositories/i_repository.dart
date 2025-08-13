import 'package:business_budget/models/products/product.dart';
import 'package:business_budget/models/rules/business_rule.dart';

abstract class IRepository<T> {
  List<T> getAll();
  T? getById(String id);
  void add(T item);
  void remove(String id);
}

// Exemplo de implementação para produtos
class ProductRepository extends IRepository<Product> {
  final List<Product> _products = [];

  @override
  List<Product> getAll() => _products;

  @override
  Product? getById(String id) {
    try {
      return _products.firstWhere((p) => p.name == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void add(Product item) => _products.add(item);

  @override
  void remove(String id) => _products.removeWhere((p) => p.name == id);
}

// Exemplo para regras
class RuleRepository extends IRepository<BusinessRule> {
  final List<BusinessRule> _rules = [];

  @override
  List<BusinessRule> getAll() => _rules;

  @override
  BusinessRule? getById(String id) => null; // Implementação conforme necessidade

  @override
  void add(BusinessRule item) => _rules.add(item);

  @override
  void remove(String id) {} // Implementação conforme necessidade
}
