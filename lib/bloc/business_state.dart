part of 'business_bloc.dart';

sealed class BusinessState extends Equatable {
  const BusinessState();

  @override
  List<Object> get props => [];
}

final class BusinessInitial extends BusinessState {}

final class ProductFormFieldsLoaded extends BusinessState {
  final String productType;
  final List<FormFieldModel> fields;
  const ProductFormFieldsLoaded(this.productType, this.fields);

  @override
  List<Object> get props => [productType, fields];
}
