// Extensions robustas conforme requisitos técnicos
import '../models/products/product.dart';

/// Extension para Products
extension ProductExtensions on Product {
  /// Verifica se produto é de alta prioridade (prazo < 7 dias)
  bool get isHighPriority => deadline < 7;

  /// Verifica se produto tem desconto por volume
  bool get hasVolumeDiscount => quantity >= 50;

  /// Calcula preço unitário
  double get unitPrice => price;

  /// Calcula preço total base (sem regras aplicadas)
  double get baseTotalPrice => price * quantity;

  /// Verifica se produto precisa de certificação
  bool get needsCertification {
    if (this is IndustrialProduct) {
      final industrial = this as IndustrialProduct;
      return industrial.voltage > 220;
    }
    return false;
  }

  /// Retorna categoria do produto
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

  /// Retorna tipo do produto como string
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

  /// Verifica se é produto válido
  bool get isValid {
    return name.isNotEmpty && price > 0 && quantity > 0 && deadline > 0;
  }

  /// Retorna resumo do produto
  String get summary {
    return '$name - ${quantity}x R\$ ${price.toStringAsFixed(2)} - $deadline dias';
  }
}

/// Extension genérica para Lists
extension ListExtensions<T> on List<T> {
  /// Verifica se lista não está vazia
  bool get isNotEmpty => !isEmpty;

  /// Retorna primeiro elemento ou null
  T? get firstOrNull => isEmpty ? null : first;

  /// Retorna último elemento ou null
  T? get lastOrNull => isEmpty ? null : last;

  /// Filtra elementos não nulos
  List<T> whereNotNull() {
    return where((element) => element != null).toList();
  }

  /// Agrupa elementos por uma função
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    Map<K, List<T>> result = {};
    for (T element in this) {
      K key = keyFunction(element);
      result.putIfAbsent(key, () => []).add(element);
    }
    return result;
  }

  /// Remove duplicatas mantendo ordem
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

  /// Encontra elemento por condição ou retorna null
  T? findWhere(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}

// Lista utilitária específica para produtos
class ProductListUtils {
  // Filtra produtos por tipo usando polimorfismo
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

  // Ordena produtos por preço
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

  // Filtra produtos por faixa de preço
  static List<Product> filterByPriceRange(
    List<Product> products,
    double min,
    double max,
  ) {
    return products.where((p) => p.price >= min && p.price <= max).toList();
  }
}

class StringExtensions {
  /// Converte string para double com tratamento de erro
  double toDouble(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  /// Converte string para int com tratamento de erro
  int toInt(String value) {
    return int.tryParse(value) ?? 0;
  }

  /// Verifica se string é um número válido
  bool isNumeric(String value) {
    return double.tryParse(value.replaceAll(',', '.')) != null;
  }

  /// Remove espaços e normaliza string
  String normalize(String value) {
    return value.trim().toLowerCase();
  }

  /// Capitaliza primeira letra
  String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  /// Verifica se string contém apenas números
  bool isDigitsOnly(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  /// Remove caracteres especiais
  String removeSpecialChars(String value) {
    return value.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Formata string como moeda brasileira
  String toCurrency(String value) {
    final doubleValue = toDouble(value);
    return 'R\$ ${doubleValue.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
