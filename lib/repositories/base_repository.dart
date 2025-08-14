abstract class BaseModel {
  String get id;
  DateTime get createdAt;
  DateTime get updatedAt;
  Map<String, dynamic> toJson();
}

abstract class IRepository<T extends BaseModel> {
  Future<T?> findById(String id);
  Future<List<T>> findAll();
  Future<T> save(T entity);
  Future<bool> deleteById(String id);
}

abstract class InMemoryRepository<T extends BaseModel>
    implements IRepository<T> {
  final Map<String, T> _storage = {};

  @override
  Future<T?> findById(String id) async => _storage[id];

  @override
  Future<List<T>> findAll() async => _storage.values.toList();

  @override
  Future<T> save(T entity) async {
    _storage[entity.id] = entity;
    return entity;
  }

  @override
  Future<bool> deleteById(String id) async => _storage.remove(id) != null;
}
