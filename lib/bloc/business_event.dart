part of 'business_bloc.dart';

sealed class BusinessEvent extends Equatable {
  const BusinessEvent();

  @override
  List<Object> get props => [];
}

class ProductSelected extends BusinessEvent {
  final String productType;
  const ProductSelected(this.productType);

  @override
  List<Object> get props => [productType];
}

class FieldChanged extends BusinessEvent {
  final String fieldName;
  final String value;
  final Map<String, String> allFields;
  final String productType;

  const FieldChanged({
    required this.fieldName,
    required this.value,
    required this.allFields,
    required this.productType,
  });

  @override
  List<Object> get props => [fieldName, value, allFields, productType];
}

class ValidateForm extends BusinessEvent {
  final Map<String, String> formData;
  final String productType;

  const ValidateForm({required this.formData, required this.productType});

  @override
  List<Object> get props => [formData, productType];
}

class CalculatePricing extends BusinessEvent {
  final Product product;

  const CalculatePricing(this.product);

  @override
  List<Object> get props => [product];
}

class RebuildForm extends BusinessEvent {}

class AppliedRules extends BusinessEvent {}

class RecalculatedPrices extends BusinessEvent {}

class ExecutedValidations extends BusinessEvent {}

class UpdatedInterface extends BusinessEvent {}

class AllFieldsFilled extends BusinessEvent {}
