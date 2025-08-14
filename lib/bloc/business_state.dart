part of 'business_bloc.dart';

sealed class BusinessState extends Equatable {
  const BusinessState();

  @override
  List<Object> get props => [];
}

final class ProductFormFieldsLoaded extends BusinessState {
  final String productType;
  final List<FormFieldModel> fields;
  const ProductFormFieldsLoaded(this.productType, this.fields);

  @override
  List<Object> get props => [productType, fields];
}

final class FormUpdatedState extends BusinessState {
  final String productType;
  final List<FormFieldModel> fields;
  final Map<String, String> allFieldsData;
  final String certificationMessage;
  final double finalPrice;
  final bool isValid;

  const FormUpdatedState({
    required this.productType,
    required this.fields,
    required this.allFieldsData,
    required this.certificationMessage,
    required this.finalPrice,
    required this.isValid,
  });

  @override
  List<Object> get props => [
    productType,
    fields,
    allFieldsData,
    certificationMessage,
    finalPrice,
    isValid,
  ];
}
