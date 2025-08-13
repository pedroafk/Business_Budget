// Repositórios específicos usando a base genérica type-safe
import '../models/products/product.dart';
import '../models/rules/business_rule.dart';
import 'base_repository.dart';

/// Modelo para Product implementando BaseModel
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
  }) : _id = id ?? RepositoryUtils.generateId(),
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
      'productType': product.runtimeType.toString(),
      'name': product.name,
      'price': product.price,
      'quantity': product.quantity,
      'deadline': product.deadline,
      // Campos específicos baseados no tipo
      if (product is IndustrialProduct) ...{
        'voltage': (product as IndustrialProduct).voltage,
        'certification': (product as IndustrialProduct).certification,
        'industrialCapacity': (product as IndustrialProduct).industrialCapacity,
      },
      if (product is ResidentialProduct) ...{
        'color': (product as ResidentialProduct).color,
        'guarantee': (product as ResidentialProduct).guarantee,
        'finishing': (product as ResidentialProduct).finishing,
      },
      if (product is CorporateProduct) ...{
        'corporateVolume': (product as CorporateProduct).corporateVolume,
        'contract': (product as CorporateProduct).contract,
        'sla': (product as CorporateProduct).sla,
      },
    };
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, product: ${product.name}, type: ${product.runtimeType})';
  }
}

/// Repository específico para Products - só funcionalidades essenciais
class ProductRepository extends InMemoryRepository<ProductModel> {
  ProductRepository() : super('Product');

  /// Busca produtos por tipo (essencial para o teste)
  Future<List<ProductModel>> findByType(String productType) async {
    return findWhere({'productType': productType});
  }

  /// Busca produtos por faixa de preço (essencial para regras)
  Future<List<ProductModel>> findByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    return findWhere({
      'price': {'min': minPrice, 'max': maxPrice},
    });
  }

  /// Busca produtos urgentes (essencial para regra de urgência)
  Future<List<ProductModel>> findUrgentProducts() async {
    final allProducts = await findAll();
    return allProducts.where((p) => p.product.deadline < 7).toList();
  }

  /// Busca produtos com desconto volume (essencial para regra de volume)
  Future<List<ProductModel>> findVolumeDiscountProducts() async {
    final allProducts = await findAll();
    return allProducts.where((p) => p.product.quantity >= 50).toList();
  }
}

/// Modelo para BusinessRule implementando BaseModel
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
  }) : _id = id ?? RepositoryUtils.generateId(),
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

  @override
  String toString() {
    return 'BusinessRuleModel(id: $id, rule: ${businessRule.runtimeType})';
  }
}

/// Repository específico para BusinessRules
class RuleRepository extends InMemoryRepository<BusinessRuleModel> {
  RuleRepository() : super('BusinessRule');

  /// Busca regras por tipo
  Future<List<BusinessRuleModel>> findByType(String ruleType) async {
    return findWhere({'ruleType': ruleType});
  }
}

/// Factory para repositórios
class RepositoryFactory {
  static final Map<Type, dynamic> _repositories = {};

  /// Obtém repository para um tipo específico
  static T getRepository<T>() {
    if (_repositories.containsKey(T)) {
      return _repositories[T] as T;
    }

    dynamic repository;

    if (T == ProductRepository) {
      repository = ProductRepository();
    } else if (T == RuleRepository) {
      repository = RuleRepository();
    } else {
      throw Exception('Repository não registrado para o tipo $T');
    }

    _repositories[T] = repository;
    return repository as T;
  }

  /// Limpa cache de repositories
  static void clearRepositories() {
    _repositories.clear();
  }
}
