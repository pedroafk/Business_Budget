import '../models/products/product.dart';
import '../utils/mixins.dart';

class ConditionEvaluator with ValidatorMixin {
  bool evaluate(String condition, Product product) {
    switch (condition) {
      case 'high_volume':
        return product.quantity >= 50;
      case 'urgent_deadline':
        return product.deadline < 7;
      case 'high_voltage':
        return product is IndustrialProduct && product.voltage > 220;
      case 'is_industrial':
        return product is IndustrialProduct;
      case 'is_residential':
        return product is ResidentialProduct;
      case 'is_corporate':
        return product is CorporateProduct;
      default:
        return false;
    }
  }
}

class ActionExecutor with CalculatorMixin, FormatterMixin {
  Map<String, dynamic> execute(String action, Product product) {
    switch (action) {
      case 'apply_volume_discount':
        final discount = calculateVolumeDiscount(
          product.quantity,
          product.price,
        );
        return {
          'discount': discount,
          'message': 'Desconto por volume aplicado',
        };
      case 'apply_urgency_fee':
        final fee = calculateUrgencyFee(product.deadline, product.price);
        return {'urgency_fee': fee, 'message': 'Taxa de urgência aplicada'};
      case 'require_certification':
        return {
          'required_fields': ['Certificação'],
          'message': 'Certificação obrigatória',
        };
      default:
        return {'message': 'Ação não reconhecida'};
    }
  }
}

class PriorityManager {
  List<BusinessRuleConfig> sortByPriority(List<BusinessRuleConfig> rules) {
    final sorted = List<BusinessRuleConfig>.from(rules);
    sorted.sort((a, b) => a.priority.compareTo(b.priority));
    return sorted;
  }
}

class BusinessRuleConfig {
  final String id;
  final String name;
  final List<String> conditions;
  final List<String> actions;
  final int priority;
  final bool isActive;

  BusinessRuleConfig({
    required this.id,
    required this.name,
    required this.conditions,
    required this.actions,
    this.priority = 0,
    this.isActive = true,
  });
}

class RulesEngine<T extends Product> {
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
    _rules.addAll([
      BusinessRuleConfig(
        id: 'volume_discount',
        name: 'Desconto por Volume',
        conditions: ['high_volume'],
        actions: ['apply_volume_discount'],
        priority: 1,
      ),
      BusinessRuleConfig(
        id: 'urgency_fee',
        name: 'Taxa de Urgência',
        conditions: ['urgent_deadline'],
        actions: ['apply_urgency_fee'],
        priority: 2,
      ),
      BusinessRuleConfig(
        id: 'certification_required',
        name: 'Certificação Obrigatória',
        conditions: ['high_voltage'],
        actions: ['require_certification'],
        priority: 3,
      ),
    ]);
  }

  Map<String, dynamic> processRules(T product) {
    final result = <String, dynamic>{
      'actions_executed': <String>[],
      'messages': <String>[],
      'price_adjustments': <String, double>{},
      'required_fields': <String>[],
    };

    final activeRules = _rules.where((rule) => rule.isActive).toList();
    final sortedRules = _priorityManager.sortByPriority(activeRules);

    for (final rule in sortedRules) {
      final conditionsMet = rule.conditions.every(
        (condition) => _conditionEvaluator.evaluate(condition, product),
      );

      if (conditionsMet) {
        for (final action in rule.actions) {
          final actionResult = _actionExecutor.execute(action, product);
          _consolidateResults(result, actionResult, rule);
        }
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

    if (actionResult.containsKey('required_fields')) {
      result['required_fields'].addAll(actionResult['required_fields']);
    }
  }

  void addRule(BusinessRuleConfig rule) => _rules.add(rule);
  void removeRule(String id) => _rules.removeWhere((rule) => rule.id == id);
}
