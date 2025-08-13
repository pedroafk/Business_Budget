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
        appBar: AppBar(
          title: const Text("Business Budget"),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.business, size: 80, color: Colors.blue.shade600),
              const SizedBox(height: 24),
              Text(
                "Sistema de Orçamentos Dinâmicos",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Builder(
                builder: (context) => ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/form');
                  },
                  icon: const Icon(Icons.calculate),
                  label: const Text("Criar Orçamento"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
