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
