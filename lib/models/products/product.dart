abstract class Product {
  final String name;
  final double price;
  final int quantity;
  final int deadline;
  Product(this.name, this.price, this.quantity, this.deadline);

  double get discountedPrice {
    double finalPrice = price;
    if (quantity >= 50) {
      finalPrice *= 0.85;
    }
    if (deadline < 7) {
      finalPrice *= 1.20;
    }
    return finalPrice;
  }
}

class IndustrialProduct extends Product {
  final int voltage;
  final String certification;
  final int industrialCapacity;

  IndustrialProduct(
    super.name,
    super.price,
    super.quantity,
    super.deadline, {
    required this.voltage,
    required this.certification,
    required this.industrialCapacity,
  });
}

class ResidentialProduct extends Product {
  final String color;
  final String guarantee;
  final String finishing;
  ResidentialProduct(
    super.name,
    super.price,
    super.quantity,
    super.deadline, {
    required this.color,
    required this.guarantee,
    required this.finishing,
  });
}

class CorporateProduct extends Product {
  final int corporateVolume;
  final String contract;
  final String sla;
  CorporateProduct(
    super.name,
    super.price,
    super.quantity,
    super.deadline, {
    required this.corporateVolume,
    required this.contract,
    required this.sla,
  });
}
