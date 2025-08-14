mixin ValidatorMixin {
  bool isInRange(double value, double min, double max) {
    return value >= min && value <= max;
  }

  bool isRequired(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  bool isPositive(double value) {
    return value > 0;
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isInAllowedValues(String value, List<String> allowedValues) {
    return allowedValues.contains(value);
  }
}

mixin CalculatorMixin {
  double calculateVolumeDiscount(int quantity, double basePrice) {
    if (quantity >= 50) {
      return basePrice * 0.15;
    }
    return 0.0;
  }

  double calculateUrgencyFee(int deadline, double basePrice) {
    if (deadline < 7) {
      return basePrice * 0.20;
    }
    return 0.0;
  }

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

  double calculatePercentage(double value, double percentage) {
    return value * (percentage / 100);
  }
}

mixin FormatterMixin {
  String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

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
  final List<Function(String, dynamic)> _observers = [];

  void addObserver(Function(String, dynamic) observer) {
    _observers.add(observer);
  }

  void removeObserver(Function(String, dynamic) observer) {
    _observers.remove(observer);
  }

  void notifyObservers(String event, dynamic data) {
    for (var observer in _observers) {
      observer(event, data);
    }
  }
}
