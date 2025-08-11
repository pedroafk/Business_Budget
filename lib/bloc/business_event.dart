part of 'business_bloc.dart';

sealed class BusinessEvent extends Equatable {
  const BusinessEvent();

  @override
  List<Object> get props => [];
}

class ProductSelected extends BusinessEvent {}

class RebuildForm extends BusinessEvent {}

class AppliedRuses extends BusinessEvent {}

class RecalculatedPrices extends BusinessEvent {}

class ExecutedValidations extends BusinessEvent {}

class UpdatedInterface extends BusinessEvent {}
