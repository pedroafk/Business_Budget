import 'package:business_budget/bloc/business_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownForm extends StatelessWidget {
  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
  );

  final _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
  );

  final Map<String, String> productTypeLabels = {
    "Corporate": "📊 Corporativo",
    "Residential": "🏠 Residencial",
    "Industrial": "🏭 Industrial",
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedType,
            decoration: InputDecoration(
              labelText: "Tipo de Produto",
              labelStyle: const TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(Icons.category, color: Color(0xFF2E7D32)),
              border: _border,
              enabledBorder: _border,
              focusedBorder: _focusedBorder,
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            dropdownColor: Colors.white,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF2E7D32),
            ),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            selectedItemBuilder: (BuildContext context) {
              return productTypes.map((String type) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    productTypeLabels[type]!,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList();
            },
            items: productTypes
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        productTypeLabels[type]!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<BusinessBloc>().add(ProductSelected(value));
              }
            },
          ),
        );
      },
    );
  }
}
