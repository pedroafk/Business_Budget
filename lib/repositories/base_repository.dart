// Repository genérico type-safe - versão simplificada para o teste

/// Modelo base para entidades
abstract class BaseModel {
  String get id;
  DateTime get createdAt;
  DateTime get updatedAt;

  Map<String, dynamic> toJson();

  @override
  String toString();
}

/// Interface genérica para repositórios type-safe
abstract class IRepository<T extends BaseModel> {
  /// Busca uma entidade por ID
  Future<T?> findById(String id);

  /// Busca todas as entidades
  Future<List<T>> findAll();

  /// Busca entidades com filtros
  Future<List<T>> findWhere(Map<String, dynamic> filters);

  /// Salva uma entidade
  Future<T> save(T entity);

  /// Remove uma entidade por ID
  Future<bool> deleteById(String id);

  /// Conta o número de entidades
  Future<int> count([Map<String, dynamic>? filters]);
}

/// Implementação base em memória
abstract class InMemoryRepository<T extends BaseModel>
    implements IRepository<T> {
  final Map<String, T> _storage = {};

  InMemoryRepository(
    String entityName,
  ); // Parâmetro mantido para compatibilidade

  @override
  Future<T?> findById(String id) async {
    return _storage[id];
  }

  @override
  Future<List<T>> findAll() async {
    return _storage.values.toList();
  }

  @override
  Future<List<T>> findWhere(Map<String, dynamic> filters) async {
    final allItems = await findAll();

    if (filters.isEmpty) return allItems;

    return allItems.where((item) {
      final itemJson = item.toJson();

      return filters.entries.every((filter) {
        final key = filter.key;
        final value = filter.value;

        if (!itemJson.containsKey(key)) return false;

        final itemValue = itemJson[key];

        // Comparação exata
        if (value is String || value is num || value is bool) {
          return itemValue == value;
        }

        // Comparação de range para números
        if (value is Map &&
            value.containsKey('min') &&
            value.containsKey('max')) {
          if (itemValue is num) {
            final min = value['min'] as num;
            final max = value['max'] as num;
            return itemValue >= min && itemValue <= max;
          }
        }

        return false;
      });
    }).toList();
  }

  @override
  Future<T> save(T entity) async {
    _storage[entity.id] = entity;
    return entity;
  }

  @override
  Future<bool> deleteById(String id) async {
    return _storage.remove(id) != null;
  }

  @override
  Future<int> count([Map<String, dynamic>? filters]) async {
    if (filters == null || filters.isEmpty) {
      return _storage.length;
    }

    final filteredItems = await findWhere(filters);
    return filteredItems.length;
  }
}

/// Utilitários para repositórios
class RepositoryUtils {
  /// Gera ID único
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
