import 'package:bloc/bloc.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:business_budget/models/rules/business_rule.dart';
import 'package:business_budget/models/products/product.dart';
import 'package:business_budget/services/factory_service.dart';
import 'package:equatable/equatable.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final ProductFactoryService _factoryService = ProductFactoryService();

  BusinessBloc()
    : super(
        ProductFormFieldsLoaded("Inicial", [
          TextFieldModel("Nome do Produto"),
          NumberFieldModel("Preço"),
          NumberFieldModel("Quantidade"),
          NumberFieldModel("Prazo (dias)"),
        ]),
      ) {
    on<ProductSelected>(_onProductSelected);
    on<FieldChanged>(_onFieldChanged);
  }

  void _onProductSelected(ProductSelected event, Emitter<BusinessState> emit) {
    final fields = VisibilityRule().getFieldsForProductType(event.productType);
    emit(ProductFormFieldsLoaded(event.productType, fields));
  }

  void _onFieldChanged(FieldChanged event, Emitter<BusinessState> emit) {
    final currentState = state;
    if (currentState is ProductFormFieldsLoaded ||
        currentState is FormUpdatedState) {
      List<FormFieldModel> currentFields;

      if (currentState is ProductFormFieldsLoaded) {
        currentFields = currentState.fields;
      } else if (currentState is FormUpdatedState) {
        currentFields = currentState.fields;
      } else {
        return;
      }

      final hasBasicFields = _hasBasicFields(event.allFields);

      if (hasBasicFields) {
        final product = _createProductFromFields(
          event.allFields,
          event.productType,
        );

        final validationRule = ValidationRule();
        final certificationMessage = validationRule.getCertificationMessage(
          product,
        );

        final pricingRule = PricingRule();
        final finalPrice = pricingRule.calculateFinalPrice(product);

        emit(
          FormUpdatedState(
            productType: event.productType,
            fields: currentFields,
            allFieldsData: event.allFields,
            certificationMessage: certificationMessage,
            finalPrice: finalPrice,
            isValid: _validateAllFields(event.allFields, event.productType),
          ),
        );
      } else {
        emit(ProductFormFieldsLoaded(event.productType, currentFields));
      }
    }
  }

  bool _hasBasicFields(Map<String, String> fields) {
    return fields["Nome do Produto"]?.isNotEmpty == true &&
        fields["Preço"]?.isNotEmpty == true &&
        fields["Quantidade"]?.isNotEmpty == true &&
        fields["Prazo (dias)"]?.isNotEmpty == true;
  }

  Product _createProductFromFields(
    Map<String, String> fields,
    String productType,
  ) {
    final params = {
      'type': productType,
      'name': fields["Nome do Produto"] ?? '',
      'price': _toDouble(fields["Preço"] ?? ''),
      'quantity': _toInt(fields["Quantidade"] ?? ''),
      'deadline': _toInt(fields["Prazo (dias)"] ?? ''),
      'voltage': _toInt(fields['Voltagem'] ?? ''),
      'certification': fields['Certificação'] ?? '',
      'industrialCapacity': _toInt(fields['Capacidade Industrial'] ?? ''),
      'color': fields['Cor'] ?? '',
      'guarantee': fields['Garantia'] ?? '',
      'finishing': fields['Acabamento'] ?? '',
      'corporateVolume': _toInt(fields['Volume Corporativo'] ?? ''),
      'contract': fields['Contrato'] ?? '',
      'sla': fields['SLA'] ?? '',
    };
    return _factoryService.create(params);
  }

  bool _validateAllFields(Map<String, String> fields, String productType) {
    if (!_hasBasicFields(fields)) return false;

    switch (productType) {
      case 'Industrial':
        return fields['Voltagem']?.isNotEmpty == true &&
            fields['Certificação']?.isNotEmpty == true &&
            fields['Capacidade Industrial']?.isNotEmpty == true;
      case 'Residential':
        return fields['Cor']?.isNotEmpty == true &&
            fields['Garantia']?.isNotEmpty == true &&
            fields['Acabamento']?.isNotEmpty == true;
      case 'Corporate':
        return fields['Volume Corporativo']?.isNotEmpty == true &&
            fields['Contrato']?.isNotEmpty == true &&
            fields['SLA']?.isNotEmpty == true;
      default:
        return true;
    }
  }

  double _toDouble(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  int _toInt(String value) {
    return int.tryParse(value) ?? 0;
  }
}
