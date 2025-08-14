import 'package:business_budget/models/products/product.dart';

abstract class FactoryService<T> {
  T create(Map<String, dynamic> params);
}

class ProductFactoryService extends FactoryService<Product> {
  @override
  Product create(Map<String, dynamic> params) {
    final type = params['type'] as String;
    switch (type) {
      case 'Industrial':
        return IndustrialProduct(
          params['name'],
          params['price'],
          params['quantity'],
          params['deadline'],
          voltage: params['voltage'],
          certification: params['certification'],
          industrialCapacity: params['industrialCapacity'],
        );
      case 'Residential':
        return ResidentialProduct(
          params['name'],
          params['price'],
          params['quantity'],
          params['deadline'],
          color: params['color'],
          guarantee: params['guarantee'],
          finishing: params['finishing'],
        );
      case 'Corporate':
        return CorporateProduct(
          params['name'],
          params['price'],
          params['quantity'],
          params['deadline'],
          corporateVolume: params['corporateVolume'],
          contract: params['contract'],
          sla: params['sla'],
        );
      default:
        return GenericProduct(
          params['name'],
          params['price'],
          params['quantity'],
          params['deadline'],
        );
    }
  }
}
