import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  BusinessBloc() : super(BusinessInitial()) {
    on<BusinessEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
