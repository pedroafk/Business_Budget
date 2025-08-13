import 'package:business_budget/bloc/business_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownForm extends StatelessWidget {
  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade400),
  );

  final Map<String, String> productTypeLabels = {
    "Corporate": "Formulário Corporativo",
    "Residential": "Formulário Residencial",
    "Industrial": "Formulário Industrial",
  };

  final List<String> productTypes = ["Corporate", "Residential", "Industrial"];

  DropdownForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessBloc, BusinessState>(
      builder: (context, state) {
        String? selectedType;
        if (state is ProductFormFieldsLoaded) {
          selectedType = state.productType != "Inicial"
              ? state.productType
              : null;
        }
        return DropdownButtonFormField<String>(
          value: selectedType,
          decoration: InputDecoration(
            labelText: "Tipo de Produto",
            border: _border,
            enabledBorder: _border,
            focusedBorder: _border,
          ),
          items: productTypes
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(productTypeLabels[type]!),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<BusinessBloc>().add(ProductSelected(value));
            }
          },
        );
      },
    );
  }
}
