import 'package:flutter/material.dart';

import 'paginas/paginainicial.dart';

void main() {
  runApp(const SimuladorInvestimentoApp());
}

class SimuladorInvestimentoApp extends StatelessWidget {
  const SimuladorInvestimentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFF126B62);

    return MaterialApp(
      title: 'Comparador de investimentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: corPrincipal,
          primary: corPrincipal,
          surface: const Color(0xFFF5F7F6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7F6),
          foregroundColor: Color(0xFF172A27),
          centerTitle: false,
        ),
        useMaterial3: true,
      ),
      home: const PaginaInicial(),
    );
  }
}
