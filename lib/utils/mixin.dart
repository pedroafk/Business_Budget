// Mixins reutilizáveis conforme requisitos técnicos

mixin ValidatorMixin {
  /// Valida se um valor está dentro do range especificado
  bool isInRange(double value, double min, double max) {
    return value >= min && value <= max;
  }

  /// Valida se um campo obrigatório está preenchido
  bool isRequired(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Valida se um valor numérico é positivo
  bool isPositive(double value) {
    return value > 0;
  }

  /// Valida formato de email
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Valida se um valor está na lista de valores permitidos
  bool isInAllowedValues(String value, List<String> allowedValues) {
    return allowedValues.contains(value);
  }
}

mixin CalculatorMixin {
  /// Calcula desconto por volume (≥50 unidades = 15%)
  double calculateVolumeDiscount(int quantity, double basePrice) {
    if (quantity >= 50) {
      return basePrice * 0.15; // 15% de desconto
    }
    return 0.0;
  }

  /// Calcula taxa de urgência (<7 dias = +20%)
  double calculateUrgencyFee(int deadline, double basePrice) {
    if (deadline < 7) {
      return basePrice * 0.20; // 20% de taxa
    }
    return 0.0;
  }

  /// Calcula preço final aplicando todas as regras
  double calculateFinalPrice({
    required double basePrice,
    required int quantity,
    required int deadline,
    double additionalFees = 0.0,
  }) {
    final volumeDiscount = calculateVolumeDiscount(quantity, basePrice);
    final urgencyFee = calculateUrgencyFee(deadline, basePrice);

    return (basePrice * quantity) -
        volumeDiscount +
        urgencyFee +
        additionalFees;
  }

  /// Calcula percentual de um valor
  double calculatePercentage(double value, double percentage) {
    return value * (percentage / 100);
  }
}

mixin FormatterMixin {
  /// Formata valor monetário em Real
  String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Formata data para padrão brasileiro
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Formata percentual
  String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  /// Formata texto para capitalização
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Formata número com separadores de milhares
  String formatNumber(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }
}

mixin NotificationMixin {
  /// Lista de observadores para notificações
  final List<Function(String, dynamic)> _observers = [];

  /// Adiciona um observador
  void addObserver(Function(String, dynamic) observer) {
    _observers.add(observer);
  }

  /// Remove um observador
  void removeObserver(Function(String, dynamic) observer) {
    _observers.remove(observer);
  }

  /// Notifica todos os observadores
  void notifyObservers(String event, dynamic data) {
    for (var observer in _observers) {
      observer(event, data);
    }
  }
}
