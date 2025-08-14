abstract class FormFieldModel {
  final String label;
  FormFieldModel(this.label);

  String? validate(String value);
}

class DoubleFieldModel extends FormFieldModel {
  DoubleFieldModel(super.label);

  @override
  String? validate(String value) {
    if (value.isEmpty) return 'Campo obrigatório';
    if (double.tryParse(value) == null) {
      return 'Deve ser um número decimal válido (ex: 10.50)';
    }
    return null;
  }
}

class IntFieldModel extends FormFieldModel {
  IntFieldModel(super.label);

  @override
  String? validate(String value) {
    if (value.isEmpty) return 'Campo obrigatório';
    if (int.tryParse(value) == null) {
      return 'Deve ser um número inteiro válido (ex: 10)';
    }
    return null;
  }
}

class TextFieldModel extends FormFieldModel {
  TextFieldModel(super.label);

  @override
  String? validate(String value) {
    if (value.isEmpty) return 'Campo obrigatório';
    if (value.trim().length < 2) {
      return 'Deve ter pelo menos 2 caracteres';
    }
    if (RegExp(r'^\d+\.?\d*$').hasMatch(value.trim())) {
      return 'Deve ser um texto, não apenas números';
    }
    return null;
  }
}

class NumberFieldModel extends FormFieldModel {
  NumberFieldModel(super.label);

  @override
  String? validate(String value) {
    if (value.isEmpty) return 'Campo obrigatório';
    if (double.tryParse(value) == null) {
      return 'Deve ser um número válido';
    }
    return null;
  }
}
