import 'package:bloc/bloc.dart';
import 'package:business_budget/models/fields/form_field_model.dart';
import 'package:business_budget/models/rules/business_rule.dart';
import 'package:business_budget/models/products/product.dart';
import 'package:business_budget/services/factory_service.dart';
import 'package:business_budget/services/rules_engine.dart';
import 'package:business_budget/strategies/business_strategies.dart';
import 'package:business_budget/utils/mixins.dart';
import 'package:equatable/equatable.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState>
    with CalculatorMixin {
  final ProductFactoryService _factoryService = ProductFactoryService();
  final RulesEngine<Product> _rulesEngine = RulesEngine<Product>();
  final Map<String, IValidationStrategy> _validationStrategies = {
    'Industrial': IndustrialValidationStrategy(),
    'Residential': ResidentialValidationStrategy(),
    'Corporate': CorporateValidationStrategy(),
  };

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

        final validationStrategy = _validationStrategies[event.productType];
        final certificationMessage =
            validationStrategy?.getValidationMessage(product) ?? "";

        final rulesResult = _rulesEngine.processRules(product);
        final priceAdjustments =
            rulesResult['price_adjustments'] as Map<String, double>? ?? {};

        double adjustedPrice = calculateFinalPrice(
          basePrice: product.price,
          quantity: product.quantity,
          deadline: product.deadline,
        );

        if (priceAdjustments.isNotEmpty) {
          adjustedPrice += priceAdjustments.values.fold(
            0.0,
            (sum, adj) => sum + adj,
          );
        }

        final finalPrice = adjustedPrice;

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
      'price': fields["Preço"]?.toDoubleValue() ?? 0.0,
      'quantity': fields["Quantidade"]?.toIntValue() ?? 0,
      'deadline': fields["Prazo (dias)"]?.toIntValue() ?? 0,
      'voltage': fields['Voltagem']?.toIntValue() ?? 0,
      'certification': fields['Certificação'] ?? '',
      'industrialCapacity': fields['Capacidade Industrial']?.toIntValue() ?? 0,
      'color': fields['Cor'] ?? '',
      'guarantee': fields['Garantia'] ?? '',
      'finishing': fields['Acabamento'] ?? '',
      'corporateVolume': fields['Volume Corporativo']?.toIntValue() ?? 0,
      'contract': fields['Contrato'] ?? '',
      'sla': fields['SLA'] ?? '',
    };
    return _factoryService.create(params);
  }

  bool _validateAllFields(Map<String, String> fields, String productType) {
    if (!_hasBasicFields(fields)) return false;

    final strategy = _validationStrategies[productType];
    if (strategy != null) {
      final product = _createProductFromFields(fields, productType);
      return strategy.validate(product);
    }

    return true;
  }
}
