part of 'business_bloc.dart';

sealed class BusinessState extends Equatable {
  const BusinessState();
  
  @override
  List<Object> get props => [];
}

final class BusinessInitial extends BusinessState {}
