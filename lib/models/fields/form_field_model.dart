abstract class FormFieldModel {
  final String label;
  FormFieldModel(this.label);
}

class NumberFieldModel extends FormFieldModel {
  NumberFieldModel(super.label);
}

class SelectFieldModel extends FormFieldModel {
  SelectFieldModel(super.label);
}

class TextFieldModel extends FormFieldModel {
  TextFieldModel(super.label);
}
