import 'package:business_budget/widgets/components/dropdown_form.dart';
import 'package:business_budget/widgets/components/form_field_widget.dart';
import 'package:business_budget/widgets/components/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_budget/bloc/business_bloc.dart';

class FormView extends StatelessWidget {
  const FormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário De Orçamento"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextTitle(
                text: "Selecione o tipo de produto:",
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              const DropdownForm(),
              BlocBuilder<BusinessBloc, BusinessState>(
                builder: (context, state) {
                  if (state is ProductFormFieldsLoaded) {
                    // Use uma Key única baseada no tipo de produto
                    return Column(
                      key: ValueKey(state.productType),
                      children: state.fields.map(buildFormField).toList(),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
