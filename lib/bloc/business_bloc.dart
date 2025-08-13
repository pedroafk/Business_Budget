import 'package:bloc/bloc.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:business_budget/models/rules/business_rule.dart';
import 'package:business_budget/models/products/product.dart';
import 'package:business_budget/services/factory_service.dart';
import 'package:business_budget/utils/extension.dart';
import 'package:equatable/equatable.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final ProductFactoryService _factoryService = ProductFactoryService();
  final StringExtensions _stringExtensions = StringExtensions();

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
    on<AllFieldsFilled>(_onAllFieldsFilled);
    on<FieldChanged>(_onFieldChanged);
    on<ValidateForm>(_onValidateForm);
    on<CalculatePricing>(_onCalculatePricing);
  }

  void _onProductSelected(ProductSelected event, Emitter<BusinessState> emit) {
    final fields = VisibilityRule().getFieldsForProductType(event.productType);
    emit(ProductFormFieldsLoaded(event.productType, fields));
  }

  void _onAllFieldsFilled(AllFieldsFilled event, Emitter<BusinessState> emit) {
    emit(FieldsCompletedState());
  }

  void _onFieldChanged(FieldChanged event, Emitter<BusinessState> emit) {
    // Estados interdependentes: quando um campo muda, recalcula tudo
    final currentState = state;
    if (currentState is ProductFormFieldsLoaded ||
        currentState is FormUpdatedState) {
      List<FormFieldModel> currentFields;

      // Pega os campos do estado atual
      if (currentState is ProductFormFieldsLoaded) {
        currentFields = currentState.fields;
      } else if (currentState is FormUpdatedState) {
        currentFields = currentState.fields;
      } else {
        return;
      }

      // Verifica se todos os campos básicos estão preenchidos
      final hasBasicFields = _hasBasicFields(event.allFields);

      if (hasBasicFields) {
        // Cria o produto para aplicar as regras
        final product = _createProductFromFields(
          event.allFields,
          event.productType,
        );

        // Aplica regras de validação
        final validationRule = ValidationRule();
        final certificationMessage = validationRule.getCertificationMessage(
          product,
        );

        // Aplica regras de preço
        final pricingRule = PricingRule();
        final finalPrice = pricingRule.calculateFinalPrice(product);

        // Emite estado com cálculos atualizados MANTENDO os campos
        emit(
          FormUpdatedState(
            productType: event.productType,
            fields: currentFields, // Mantém os campos atuais
            allFieldsData: event.allFields,
            certificationMessage: certificationMessage,
            finalPrice: finalPrice,
            isValid: _validateAllFields(event.allFields, event.productType),
          ),
        );
      } else {
        // Se campos básicos não estão preenchidos, mantém o estado atual mas sem cálculos
        emit(ProductFormFieldsLoaded(event.productType, currentFields));
      }
    }
  }

  void _onValidateForm(ValidateForm event, Emitter<BusinessState> emit) {
    _validateAllFields(event.formData, event.productType);
    // Implementar validação específica se necessário
  }

  void _onCalculatePricing(
    CalculatePricing event,
    Emitter<BusinessState> emit,
  ) {
    final pricingRule = PricingRule();
    pricingRule.calculateFinalPrice(event.product);
    // Implementar emissão de estado com preço calculado
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
      'price': _stringExtensions.toDouble(fields["Preço"] ?? ''),
      'quantity': _stringExtensions.toInt(fields["Quantidade"] ?? ''),
      'deadline': _stringExtensions.toInt(fields["Prazo (dias)"] ?? ''),
      'voltage': _stringExtensions.toInt(fields['Voltagem'] ?? ''),
      'certification': fields['Certificação'] ?? '',
      'industrialCapacity': _stringExtensions.toInt(
        fields['Capacidade Industrial'] ?? '',
      ),
      'color': fields['Cor'] ?? '',
      'guarantee': fields['Garantia'] ?? '',
      'finishing': fields['Acabamento'] ?? '',
      'corporateVolume': _stringExtensions.toInt(
        fields['Volume Corporativo'] ?? '',
      ),
      'contract': fields['Contrato'] ?? '',
      'sla': fields['SLA'] ?? '',
    };
    return _factoryService.create(params);
  }

  bool _validateAllFields(Map<String, String> fields, String productType) {
    // Implementar validação completa baseada no tipo de produto
    if (!_hasBasicFields(fields)) return false;

    // Validações específicas por tipo
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
}
