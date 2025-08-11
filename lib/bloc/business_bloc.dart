import 'package:bloc/bloc.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:equatable/equatable.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  BusinessBloc() : super(BusinessInitial()) {
    on<ProductSelected>((event, emit) {
      List<FormFieldModel> fields;
      switch (event.productType) {
        case "Corporate":
          fields = [
            NumberFieldModel("Volume Corporativo"),
            TextFieldModel("Contrato"),
            TextFieldModel("SLA"),
          ];
          break;
        case "Residential":
          fields = [
            TextFieldModel("Cor"),
            TextFieldModel("Garantia"),
            TextFieldModel("Acabamento"),
          ];
          break;
        case "Industrial":
          fields = [
            NumberFieldModel("Voltagem"),
            TextFieldModel("Certificação"),
            NumberFieldModel("Capacidade Industrial"),
          ];
          break;
        default:
          fields = [];
      }
      emit(ProductFormFieldsLoaded(event.productType, fields));
    });
  }
}
