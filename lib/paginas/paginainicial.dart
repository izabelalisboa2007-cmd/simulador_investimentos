import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/simulador.dart';
import 'paginaresultado.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final _formKey = GlobalKey<FormState>();
  final _capital1Controller = TextEditingController();
  final _aporte1Controller = TextEditingController();
  final _taxa1Controller = TextEditingController();
  final _capital2Controller = TextEditingController();
  final _aporte2Controller = TextEditingController();
  final _taxa2Controller = TextEditingController();
  final _periodoController = TextEditingController();

  @override
  void dispose() {
    _capital1Controller.dispose();
    _aporte1Controller.dispose();
    _taxa1Controller.dispose();
    _capital2Controller.dispose();
    _aporte2Controller.dispose();
    _taxa2Controller.dispose();
    _periodoController.dispose();
    super.dispose();
  }

  double? _lerNumero(String valor) =>
      double.tryParse(valor.trim().replaceAll(',', '.'));

  String? _validarValorNaoNegativo(String? valor) {
    final numero = valor == null ? null : _lerNumero(valor);
    if (numero == null || !numero.isFinite) {
      return 'Informe um número válido.';
    }
    if (numero < 0) {
      return 'O valor não pode ser negativo.';
    }
    return null;
  }

  String? _validarTaxa(String? valor) {
    final numero = valor == null ? null : _lerNumero(valor);
    if (numero == null || !numero.isFinite) {
      return 'Informe uma taxa válida.';
    }
    if (numero < -100) {
      return 'A taxa não pode ser menor que -100%.';
    }
    return null;
  }

  String? _validarPeriodo(String? valor) {
    final meses = valor == null ? null : int.tryParse(valor.trim());
    if (meses == null) {
      return 'Informe um número inteiro de meses.';
    }
    if (meses < 1 || meses > 600) {
      return 'Use um período entre 1 e 600 meses.';
    }
    return null;
  }

  Future<void> _calcular() async {
    if (!_formKey.currentState!.validate()) return;

    final periodo = int.parse(_periodoController.text.trim());
    final investimento1 = Investimento(
      nome: 'Investimento 1',
      capitalInicial: _lerNumero(_capital1Controller.text)!,
      aporteMensal: _lerNumero(_aporte1Controller.text)!,
      taxaMensalPercentual: _lerNumero(_taxa1Controller.text)!,
    );
    final investimento2 = Investimento(
      nome: 'Investimento 2',
      capitalInicial: _lerNumero(_capital2Controller.text)!,
      aporteMensal: _lerNumero(_aporte2Controller.text)!,
      taxaMensalPercentual: _lerNumero(_taxa2Controller.text)!,
    );

    final reiniciar = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PaginaResultado(
          simulacao1: investimento1.simular(periodo),
          simulacao2: investimento2.simular(periodo),
        ),
      ),
    );

    if (reiniciar == true && mounted) {
      setState(() {
        for (final controller in [
          _capital1Controller,
          _aporte1Controller,
          _taxa1Controller,
          _capital2Controller,
          _aporte2Controller,
          _taxa2Controller,
          _periodoController,
        ]) {
          controller.clear();
        }
      });
    }
  }

  Widget _campoNumero({
    required String rotulo,
    required String chave,
    required TextEditingController controller,
    required String? Function(String?) validar,
    required String sufixo,
    bool decimal = true,
  }) {
    return TextFormField(
      key: ValueKey(chave),
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: decimal,
        signed: chave.contains('taxa'),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.\-]')),
      ],
      decoration: InputDecoration(
        labelText: rotulo,
        suffixText: sufixo,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validar,
    );
  }

  Widget _cartaoInvestimento({
    required String titulo,
    required String chave,
    required TextEditingController capital,
    required TextEditingController aporte,
    required TextEditingController taxa,
    required Color cor,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 14, color: cor),
                const SizedBox(width: 10),
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _campoNumero(
              rotulo: 'Capital inicial',
              chave: '${chave}_capital',
              controller: capital,
              validar: _validarValorNaoNegativo,
              sufixo: 'R\$',
            ),
            const SizedBox(height: 14),
            _campoNumero(
              rotulo: 'Aplicação mensal',
              chave: '${chave}_aporte',
              controller: aporte,
              validar: _validarValorNaoNegativo,
              sufixo: 'R\$',
            ),
            const SizedBox(height: 14),
            _campoNumero(
              rotulo: 'Taxa de juros mensal',
              chave: '${chave}_taxa',
              controller: taxa,
              validar: _validarTaxa,
              sufixo: '%',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Simulador de investimentos')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Compare seus planos',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF172A27),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Informe os valores e veja como cada investimento pode evoluir.',
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: cores.onSurfaceVariant),
              ),
              const SizedBox(height: 22),
              _cartaoInvestimento(
                titulo: 'Investimento 1',
                chave: 'investimento1',
                capital: _capital1Controller,
                aporte: _aporte1Controller,
                taxa: _taxa1Controller,
                cor: cores.primary,
              ),
              const SizedBox(height: 12),
              _cartaoInvestimento(
                titulo: 'Investimento 2',
                chave: 'investimento2',
                capital: _capital2Controller,
                aporte: _aporte2Controller,
                taxa: _taxa2Controller,
                cor: const Color(0xFFDB8B34),
              ),
              const SizedBox(height: 12),
              _campoNumero(
                rotulo: 'Período da simulação',
                chave: 'periodo',
                controller: _periodoController,
                validar: _validarPeriodo,
                sufixo: 'meses',
                decimal: false,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _calcular,
                icon: const Icon(Icons.compare_arrows),
                label: const Text('Comparar investimentos'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
