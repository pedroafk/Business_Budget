import 'package:business_budget/bloc/business_bloc.dart';
import 'package:business_budget/presentation/quote_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(create: (context) => BusinessBloc(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Business Budget",
      routes: {'/form': (context) => const QuotePage()},
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/form');
              },
              child: const Text("Iniciar Orçamento"),
            ),
          ),
        ),
      ),
    );
  }
}
