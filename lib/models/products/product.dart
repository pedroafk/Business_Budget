abstract class Product {
  final String name;
  final double price;
  Product(this.name, this.price);
}

class IndustrialProduct extends Product {
  final String voltage;
  final String certification;
  final String industrialCapacity;

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
  final String guarantee;
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
  final String corporateVolume;
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
