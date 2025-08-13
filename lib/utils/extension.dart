import 'package:business_budget/models/products/product.dart';

class ProductExtensions {}

class ListExtensions {
  // Exemplo: filtrar produtos por tipo
  List<Product> filterByType(List<Product> products, String type) {
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
}

class StringExtensions {
  double toDouble(String value) => double.tryParse(value) ?? 0.0;
  int toInt(String value) => int.tryParse(value) ?? 0;
}
