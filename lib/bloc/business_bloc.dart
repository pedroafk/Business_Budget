import 'package:bloc/bloc.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:equatable/equatable.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  BusinessBloc()
    : super(
        ProductFormFieldsLoaded("Inicial", [
          TextFieldModel("Nome do Produto"),
          NumberFieldModel("Preço"),
        ]),
      ) {
    on<ProductSelected>((event, emit) {
      List<FormFieldModel> fields = [
        TextFieldModel("Nome do Produto"),
        NumberFieldModel("Preço"),
      ];
      switch (event.productType) {
        case "Corporate":
          fields.addAll([
            NumberFieldModel("Volume Corporativo"),
            TextFieldModel("Contrato"),
            TextFieldModel("SLA"),
          ]);
          break;
        case "Residential":
          fields.addAll([
            TextFieldModel("Cor"),
            TextFieldModel("Garantia"),
            TextFieldModel("Acabamento"),
          ]);
          break;
        case "Industrial":
          fields.addAll([
            NumberFieldModel("Voltagem"),
            TextFieldModel("Certificação"),
            NumberFieldModel("Capacidade Industrial"),
          ]);
          break;
        default:
          // Só os campos iniciais
          break;
      }
      emit(ProductFormFieldsLoaded(event.productType, fields));
    });
  }
}
