import '../models/products/product.dart';
import '../models/rules/business_rule.dart';
import 'base_repository.dart';

class ProductModel extends BaseModel {
  final Product product;
  final String _id;
  final DateTime _createdAt;
  final DateTime _updatedAt;

  ProductModel({
    required this.product,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       _createdAt = createdAt ?? DateTime.now(),
       _updatedAt = updatedAt ?? DateTime.now();

  @override
  String get id => _id;

  @override
  DateTime get createdAt => _createdAt;

  @override
  DateTime get updatedAt => _updatedAt;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'name': product.name,
      'price': product.price,
      'quantity': product.quantity,
      'deadline': product.deadline,
    };
  }
}

class BusinessRuleModel extends BaseModel {
  final BusinessRule businessRule;
  final String _id;
  final DateTime _createdAt;
  final DateTime _updatedAt;

  BusinessRuleModel({
    required this.businessRule,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       _createdAt = createdAt ?? DateTime.now(),
       _updatedAt = updatedAt ?? DateTime.now();

  @override
  String get id => _id;

  @override
  DateTime get createdAt => _createdAt;

  @override
  DateTime get updatedAt => _updatedAt;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'ruleType': businessRule.runtimeType.toString(),
    };
  }
}

class ProductRepository extends InMemoryRepository<ProductModel> {}

class RuleRepository extends InMemoryRepository<BusinessRuleModel> {}
