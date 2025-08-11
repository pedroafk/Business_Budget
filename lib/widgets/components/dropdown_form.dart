import 'package:business_budget/bloc/business_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropdownForm extends StatefulWidget {
  const DropdownForm({super.key});

  @override
  State<DropdownForm> createState() => _DropdownFormState();
}

class _DropdownFormState extends State<DropdownForm> {
  String? selectedValue;

  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [
    DropdownMenuEntry(label: "Formulário Corporativo", value: "Corporate"),
    DropdownMenuEntry(label: "Formulário Residencial", value: "Residential"),
    DropdownMenuEntry(label: "Formulário Industrial", value: "Industrial"),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      dropdownMenuEntries: dropdownMenuEntries,
      initialSelection: selectedValue,
      onSelected: (value) {
        setState(() {
          selectedValue = value;
        });
        if (value != null) {
          context.read<BusinessBloc>().add(ProductSelected(value));
        }
      },
      width: MediaQuery.of(context).size.width,
    );
  }
}
