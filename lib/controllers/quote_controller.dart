import 'package:business_budget/models/products/product.dart';
import 'package:business_budget/services/factory_service.dart';
import 'package:flutter/material.dart';

class QuoteController {
  final ProductFactoryService factoryService = ProductFactoryService();

  Product buildProduct(
    String productType,
    Map<String, TextEditingController> controllers, {
    required String name,
    required double price,
    required int quantity,
    required int deadline,
  }) {
    final params = {
      'type': productType,
      'name': name,
      'price': price,
      'quantity': quantity,
      'deadline': deadline,
      'voltage': int.tryParse(controllers['Voltagem']?.text ?? '') ?? 0,
      'certification': controllers['Certificação']?.text ?? '',
      'industrialCapacity':
          int.tryParse(controllers['Capacidade Industrial']?.text ?? '') ?? 0,
      'color': controllers['Cor']?.text ?? '',
      'guarantee': controllers['Garantia']?.text ?? '',
      'finishing': controllers['Acabamento']?.text ?? '',
      'corporateVolume':
          int.tryParse(controllers['Volume Corporativo']?.text ?? '') ?? 0,
      'contract': controllers['Contrato']?.text ?? '',
      'sla': controllers['SLA']?.text ?? '',
    };
    return factoryService.create(params);
  }
}
