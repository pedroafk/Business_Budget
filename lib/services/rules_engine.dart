import '../models/products/product.dart';
import '../models/rules/business_rule.dart';
import '../utils/mixin.dart';

class ConditionEvaluator with ValidatorMixin {
  bool evaluate(
    String condition,
    Product product,
    Map<String, dynamic> context,
  ) {
    switch (condition) {
      case 'high_volume':
        return product.quantity >= 50;
      case 'urgent_deadline':
        return product.deadline < 7;
      case 'high_voltage':
        return product is IndustrialProduct && product.voltage > 220;
      case 'requires_certification':
        return product is IndustrialProduct &&
            product.voltage > 220 &&
            (product.certification.isEmpty);
      case 'is_industrial':
        return product is IndustrialProduct;
      case 'is_residential':
        return product is ResidentialProduct;
      case 'is_corporate':
        return product is CorporateProduct;
      case 'high_capacity':
        return product is IndustrialProduct &&
            product.industrialCapacity > 1000;
      case 'corporate_volume':
        return product is CorporateProduct && product.corporateVolume >= 100;
      default:
        return false;
    }
  }

  bool evaluateComplex(
    List<String> conditions,
    String operator,
    Product product,
    Map<String, dynamic> context,
  ) {
    final results = conditions
        .map((c) => evaluate(c, product, context))
        .toList();

    switch (operator.toLowerCase()) {
      case 'and':
        return results.every((r) => r);
      case 'or':
        return results.any((r) => r);
      case 'not':
        return !results.first;
      default:
        return false;
    }
  }
}

class ActionExecutor with CalculatorMixin, FormatterMixin {
  Map<String, dynamic> executeAction(
    String action,
    Product product,
    Map<String, dynamic> context, {
    Map<String, dynamic> parameters = const {},
  }) {
    final result = <String, dynamic>{};

    switch (action) {
      case 'apply_volume_discount':
        final discount = calculateVolumeDiscount(
          product.quantity,
          product.price,
        );
        result['discount'] = discount;
        result['message'] =
            'Desconto por volume aplicado: ${formatCurrency(discount)}';
        break;

      case 'apply_urgency_fee':
        final fee = calculateUrgencyFee(product.deadline, product.price);
        result['urgency_fee'] = fee;
        result['message'] = 'Taxa de urgência aplicada: ${formatCurrency(fee)}';
        break;

      case 'require_certification':
        result['required_fields'] = ['Certificação'];
        result['message'] =
            'Certificação obrigatória para equipamentos com voltagem superior a 220V';
        break;

      case 'show_industrial_fields':
        result['visible_fields'] = [
          'Voltagem',
          'Certificação',
          'Capacidade Industrial',
        ];
        result['message'] = 'Campos específicos para produto industrial';
        break;

      case 'show_residential_fields':
        result['visible_fields'] = ['Cor', 'Garantia', 'Acabamento'];
        result['message'] = 'Campos específicos para produto residencial';
        break;

      case 'show_corporate_fields':
        result['visible_fields'] = ['Volume Corporativo', 'Contrato', 'SLA'];
        result['message'] = 'Campos específicos para produto corporativo';
        break;

      case 'calculate_industrial_fee':
        if (product is IndustrialProduct) {
          double additionalFee = 0.0;
          if (product.voltage > 220) additionalFee += product.price * 0.1;
          if (product.industrialCapacity > 1000) {
            additionalFee += product.price * 0.05;
          }
          result['industrial_fee'] = additionalFee;
          result['message'] =
              'Taxa industrial aplicada: ${formatCurrency(additionalFee)}';
        }
        break;

      default:
        result['message'] = 'Ação não reconhecida: $action';
    }

    return result;
  }
}

class PriorityManager {
  List<BusinessRuleConfig> sortByPriority(List<BusinessRuleConfig> rules) {
    final sorted = List<BusinessRuleConfig>.from(rules);
    sorted.sort((a, b) => a.priority.compareTo(b.priority));
    return sorted;
  }

  List<BusinessRuleConfig> filterByContext(
    List<BusinessRuleConfig> rules,
    String context,
  ) {
    return rules
        .where(
          (rule) => rule.contexts.isEmpty || rule.contexts.contains(context),
        )
        .toList();
  }
}

class BusinessRuleConfig {
  final String id;
  final String name;
  final String description;
  final List<String> conditions;
  final String conditionOperator;
  final List<String> actions;
  final int priority;
  final List<String> contexts;
  final bool isActive;

  BusinessRuleConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.conditions,
    this.conditionOperator = 'and',
    required this.actions,
    this.priority = 0,
    this.contexts = const [],
    this.isActive = true,
  });
}

class RulesEngine {
  final ConditionEvaluator _conditionEvaluator;
  final ActionExecutor _actionExecutor;
  final PriorityManager _priorityManager;
  final List<BusinessRuleConfig> _rules = [];

  RulesEngine({
    ConditionEvaluator? conditionEvaluator,
    ActionExecutor? actionExecutor,
    PriorityManager? priorityManager,
  }) : _conditionEvaluator = conditionEvaluator ?? ConditionEvaluator(),
       _actionExecutor = actionExecutor ?? ActionExecutor(),
       _priorityManager = priorityManager ?? PriorityManager() {
    _initializeDefaultRules();
  }

  void _initializeDefaultRules() {
    addRule(
      BusinessRuleConfig(
        id: 'volume_discount',
        name: 'Desconto por Volume',
        description: 'Desconto de 15% para pedidos com 50+ unidades',
        conditions: ['high_volume'],
        actions: ['apply_volume_discount'],
        priority: 1,
        contexts: ['pricing'],
      ),
    );

    addRule(
      BusinessRuleConfig(
        id: 'urgency_fee',
        name: 'Taxa de Urgência',
        description: 'Taxa de 20% para prazos menores que 7 dias',
        conditions: ['urgent_deadline'],
        actions: ['apply_urgency_fee'],
        priority: 2,
        contexts: ['pricing'],
      ),
    );

    addRule(
      BusinessRuleConfig(
        id: 'certification_required',
        name: 'Certificação Obrigatória',
        description: 'Certificação obrigatória para equipamentos >220V',
        conditions: ['high_voltage'],
        actions: ['require_certification'],
        priority: 3,
        contexts: ['validation'],
      ),
    );

    addRule(
      BusinessRuleConfig(
        id: 'industrial_fields',
        name: 'Campos Industriais',
        description: 'Mostra campos específicos para produtos industriais',
        conditions: ['is_industrial'],
        actions: ['show_industrial_fields'],
        priority: 0,
        contexts: ['visibility'],
      ),
    );

    addRule(
      BusinessRuleConfig(
        id: 'residential_fields',
        name: 'Campos Residenciais',
        description: 'Mostra campos específicos para produtos residenciais',
        conditions: ['is_residential'],
        actions: ['show_residential_fields'],
        priority: 0,
        contexts: ['visibility'],
      ),
    );

    addRule(
      BusinessRuleConfig(
        id: 'corporate_fields',
        name: 'Campos Corporativos',
        description: 'Mostra campos específicos para produtos corporativos',
        conditions: ['is_corporate'],
        actions: ['show_corporate_fields'],
        priority: 0,
        contexts: ['visibility'],
      ),
    );

    addRule(
      BusinessRuleConfig(
        id: 'industrial_fee',
        name: 'Taxa Industrial',
        description: 'Taxa adicional para produtos industriais',
        conditions: ['is_industrial'],
        actions: ['calculate_industrial_fee'],
        priority: 4,
        contexts: ['pricing'],
      ),
    );
  }

  void addRule(BusinessRuleConfig rule) {
    _rules.add(rule);
  }

  void removeRule(String id) {
    _rules.removeWhere((rule) => rule.id == id);
  }

  Map<String, dynamic> processRules(
    Product product,
    String context, {
    Map<String, dynamic> additionalContext = const {},
  }) {
    final result = <String, dynamic>{
      'actions_executed': <String>[],
      'messages': <String>[],
      'price_adjustments': <String, double>{},
      'required_fields': <String>[],
      'visible_fields': <String>[],
      'validations': <String>[],
    };

    final activeRules = _priorityManager.filterByContext(
      _rules.where((rule) => rule.isActive).toList(),
      context,
    );

    final sortedRules = _priorityManager.sortByPriority(activeRules);

    for (final rule in sortedRules) {
      try {
        final conditionsMet = _conditionEvaluator.evaluateComplex(
          rule.conditions,
          rule.conditionOperator,
          product,
          additionalContext,
        );

        if (conditionsMet) {
          for (final action in rule.actions) {
            final actionResult = _actionExecutor.executeAction(
              action,
              product,
              additionalContext,
            );

            _consolidateResults(result, actionResult, rule);
          }
        }
      } catch (e) {
        result['messages'].add('Erro ao processar regra ${rule.name}: $e');
      }
    }

    return result;
  }

  void _consolidateResults(
    Map<String, dynamic> result,
    Map<String, dynamic> actionResult,
    BusinessRuleConfig rule,
  ) {
    result['actions_executed'].add(rule.id);

    if (actionResult.containsKey('message')) {
      result['messages'].add(actionResult['message']);
    }

    if (actionResult.containsKey('discount')) {
      result['price_adjustments']['discount'] = actionResult['discount'];
    }

    if (actionResult.containsKey('urgency_fee')) {
      result['price_adjustments']['urgency_fee'] = actionResult['urgency_fee'];
    }

    if (actionResult.containsKey('industrial_fee')) {
      result['price_adjustments']['industrial_fee'] =
          actionResult['industrial_fee'];
    }

    if (actionResult.containsKey('required_fields')) {
      result['required_fields'].addAll(actionResult['required_fields']);
    }

    if (actionResult.containsKey('visible_fields')) {
      result['visible_fields'].addAll(actionResult['visible_fields']);
    }
  }

  List<BusinessRuleConfig> getActiveRules() {
    return _rules.where((rule) => rule.isActive).toList();
  }

  void toggleRule(String id, bool isActive) {
    final ruleIndex = _rules.indexWhere((rule) => rule.id == id);
    if (ruleIndex != -1) {
      final rule = _rules[ruleIndex];
      _rules[ruleIndex] = BusinessRuleConfig(
        id: rule.id,
        name: rule.name,
        description: rule.description,
        conditions: rule.conditions,
        conditionOperator: rule.conditionOperator,
        actions: rule.actions,
        priority: rule.priority,
        contexts: rule.contexts,
        isActive: isActive,
      );
    }
  }
}

abstract class RulesEngineInterface<T> {
  void applyRules(T item, List<BusinessRule> rules);
}

class ProductRulesEngine extends RulesEngineInterface<Product> {
  final RulesEngine _engine = RulesEngine();

  @override
  void applyRules(Product product, List<BusinessRule> rules) {
    for (var rule in rules) {
      rule.apply(product);
    }
  }

  Map<String, dynamic> processAdvancedRules(Product product, String context) {
    return _engine.processRules(product, context);
  }
}
