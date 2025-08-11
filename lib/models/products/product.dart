abstract class Product {
  final String name;
  final double price;
  Product(this.name, this.price);
}

class IndustrialProduct extends Product {
  final int voltage;
  final String certification;
  final int industrialCapacity;

  IndustrialProduct(
    super.name,
    super.price, {
    required this.voltage,
    required this.certification,
    required this.industrialCapacity,
  });
}

class ResidentialProduct extends Product {
  final String color;
  final int guarantee;
  final String finishing;
  ResidentialProduct(
    super.name,
    super.price, {
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
    super.price, {
    required this.corporateVolume,
    required this.contract,
    required this.sla,
  });
}
