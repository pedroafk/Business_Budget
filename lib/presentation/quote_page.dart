import 'package:business_budget/presentation/components/dropdown_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_budget/bloc/business_bloc.dart';
import 'dynamic_form_widget.dart';

class QuotePage extends StatelessWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulário de Orçamento")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownForm(),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<BusinessBloc, BusinessState>(
                builder: (context, state) {
                  if (state is ProductFormFieldsLoaded) {
                    return DynamicFormWidget(fields: state.fields);
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
