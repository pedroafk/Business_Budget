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

class RebuildForm extends BusinessEvent {}

class AppliedRules extends BusinessEvent {}

class RecalculatedPrices extends BusinessEvent {}

class ExecutedValidations extends BusinessEvent {}

class UpdatedInterface extends BusinessEvent {}
