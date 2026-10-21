import 'package:flutter/material.dart';

import '../models/simulador.dart';

class PaginaResultado extends StatelessWidget {
  const PaginaResultado({
    super.key,
    required this.simulacao1,
    required this.simulacao2,
  });

  final Simulacao simulacao1;
  final Simulacao simulacao2;

  static String _formatarMoeda(double valor) {
    final sinal = valor < 0 ? '-' : '';
    final inteiro = valor.abs().truncate().toString();
    final agrupado = StringBuffer();
    for (var i = 0; i < inteiro.length; i++) {
      if (i > 0 && (inteiro.length - i) % 3 == 0) {
        agrupado.write('.');
      }
      agrupado.write(inteiro[i]);
    }
    final centavos = (valor.abs() % 1).toStringAsFixed(2).substring(2);
    return 'R\$ $sinal${agrupado.toString()},$centavos';
  }

  Widget _cartaoResumo({
    required BuildContext context,
    required Simulacao simulacao,
    required Color cor,
  }) {
    final textoCor = Theme.of(context).colorScheme.onSurface;
    return Expanded(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cor.withValues(alpha: 0.45)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 12, color: cor),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      simulacao.investimento.nome,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: textoCor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Montante final',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  _formatarMoeda(simulacao.montanteFinal),
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Rendimento: ${_formatarMoeda(simulacao.rendimentoTotal)}',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: cor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _celula(
    String texto, {
    required double largura,
    TextAlign alinhamento = TextAlign.left,
    FontWeight peso = FontWeight.normal,
    Color? cor,
  }) {
    return SizedBox(
      width: largura,
      child: Text(
        texto,
        textAlign: alinhamento,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: peso, color: cor, fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalMeses = simulacao1.evolucaoMensal.length - 1;
    final cor1 = Theme.of(context).colorScheme.primary;
    const cor2 = Color(0xFFDB8B34);

    return Scaffold(
      appBar: AppBar(title: const Text('Comparação dos resultados')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Resumo da simulação',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cartaoResumo(
                  context: context,
                  simulacao: simulacao1,
                  cor: cor1,
                ),
                const SizedBox(width: 8),
                _cartaoResumo(
                  context: context,
                  simulacao: simulacao2,
                  cor: cor2,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Evolução mês a mês',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 390,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    _celula('Mês', largura: 54, peso: FontWeight.bold),
                    _celula(
                      'Investimento 1',
                      largura: 158,
                      alinhamento: TextAlign.right,
                      peso: FontWeight.bold,
                      cor: cor1,
                    ),
                    _celula(
                      'Investimento 2',
                      largura: 158,
                      alinhamento: TextAlign.right,
                      peso: FontWeight.bold,
                      cor: cor2,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                key: const ValueKey('evolucao_mensal'),
                itemCount: totalMeses + 1,
                itemBuilder: (context, indice) {
                  final mes = indice == 0 ? 'Inicial' : '$indice';
                  final corFundo = indice.isEven
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.surfaceContainerLow;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 390,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      color: corFundo,
                      child: Row(
                        children: [
                          _celula(mes, largura: 54),
                          _celula(
                            _formatarMoeda(simulacao1.evolucaoMensal[indice]),
                            largura: 158,
                            alinhamento: TextAlign.right,
                          ),
                          _celula(
                            _formatarMoeda(simulacao2.evolucaoMensal[indice]),
                            largura: 158,
                            alinhamento: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: const ValueKey('nova_comparacao'),
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.refresh),
              label: const Text('Nova comparação'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
