import '../models/products/product.dart';

extension ProductExtensions on Product {
  bool get isHighPriority => deadline < 7;

  bool get hasVolumeDiscount => quantity >= 50;

  double get unitPrice => price;

  double get baseTotalPrice => price * quantity;

  bool get needsCertification {
    if (this is IndustrialProduct) {
      final industrial = this as IndustrialProduct;
      return industrial.voltage > 220;
    }
    return false;
  }

  String get category {
    if (this is IndustrialProduct) {
      return 'Equipamento Industrial';
    } else if (this is ResidentialProduct) {
      return 'Produto Residencial';
    } else if (this is CorporateProduct) {
      return 'Solução Corporativa';
    }
    return 'Produto Genérico';
  }

  String get productType {
    if (this is IndustrialProduct) {
      return 'Industrial';
    } else if (this is ResidentialProduct) {
      return 'Residential';
    } else if (this is CorporateProduct) {
      return 'Corporate';
    }
    return 'Generic';
  }

  bool get isValid {
    return name.isNotEmpty && price > 0 && quantity > 0 && deadline > 0;
  }

  String get summary {
    return '$name - ${quantity}x R\$ ${price.toStringAsFixed(2)} - $deadline dias';
  }
}

extension ListExtensions<T> on List<T> {
  bool get isNotEmpty => !isEmpty;

  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;

  List<T> whereNotNull() {
    return where((element) => element != null).toList();
  }

  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    Map<K, List<T>> result = {};
    for (T element in this) {
      K key = keyFunction(element);
      result.putIfAbsent(key, () => []).add(element);
    }
    return result;
  }

  List<T> removeDuplicates() {
    List<T> result = [];
    Set<T> seen = {};
    for (T element in this) {
      if (!seen.contains(element)) {
        seen.add(element);
        result.add(element);
      }
    }
    return result;
  }

  T? findWhere(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}

class ProductListUtils {
  static List<Product> filterByType(List<Product> products, String type) {
    switch (type) {
      case 'Industrial':
        return products.whereType<IndustrialProduct>().toList();
      case 'Residential':
        return products.whereType<ResidentialProduct>().toList();
      case 'Corporate':
        return products.whereType<CorporateProduct>().toList();
      default:
        return products;
    }
  }

  static List<Product> sortByPrice(
    List<Product> products, {
    bool ascending = true,
  }) {
    final sorted = List<Product>.from(products);
    sorted.sort(
      (a, b) =>
          ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price),
    );
    return sorted;
  }

  static List<Product> filterByPriceRange(
    List<Product> products,
    double min,
    double max,
  ) {
    return products.where((p) => p.price >= min && p.price <= max).toList();
  }
}

class StringExtensions {
  double toDouble(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  int toInt(String value) {
    return int.tryParse(value) ?? 0;
  }

  bool isNumeric(String value) {
    return double.tryParse(value.replaceAll(',', '.')) != null;
  }

  String normalize(String value) {
    return value.trim().toLowerCase();
  }

  String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  bool isDigitsOnly(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  String removeSpecialChars(String value) {
    return value.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  String toCurrency(String value) {
    final doubleValue = toDouble(value);
    return 'R\$ ${doubleValue.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
