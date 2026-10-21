import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simulador_investimento/main.dart';
import 'package:simulador_investimento/models/simulador.dart';

void main() {
  group('Investimento', () {
    test('calcula saldo composto e rendimento incluindo aportes', () {
      const investimento = Investimento(
        nome: 'Teste',
        capitalInicial: 1000,
        aporteMensal: 100,
        taxaMensalPercentual: 1,
      );

      final simulacao = investimento.simular(2);

      expect(simulacao.evolucaoMensal, [1000, 1110, 1221.1]);
      expect(simulacao.totalInvestido, 1200);
      expect(simulacao.montanteFinal, 1221.1);
      expect(simulacao.rendimentoTotal, closeTo(21.1, 0.000001));
    });
  });

  testWidgets('compara dois investimentos e permite iniciar novamente', (
    tester,
  ) async {
    await tester.pumpWidget(const SimuladorInvestimentoApp());

    Future<void> preencher(String chave, String valor) async {
      await tester.enterText(find.byKey(ValueKey(chave)), valor);
    }

    await preencher('investimento1_capital', '1000');
    await preencher('investimento1_aporte', '100');
    await preencher('investimento1_taxa', '1');
    await preencher('investimento2_capital', '500');
    await preencher('investimento2_aporte', '50');
    await preencher('investimento2_taxa', '2');
    await preencher('periodo', '2');

    await tester.ensureVisible(find.text('Comparar investimentos'));
    await tester.tap(find.text('Comparar investimentos'));
    await tester.pumpAndSettle();

    expect(find.text('Comparação dos resultados'), findsOneWidget);
    expect(find.text('R\$ 1.221,10'), findsWidgets);
    expect(find.text('R\$ 621,20'), findsWidgets);
    expect(find.byKey(const ValueKey('evolucao_mensal')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('nova_comparacao')));
    await tester.tap(find.byKey(const ValueKey('nova_comparacao')));
    await tester.pumpAndSettle();

    expect(find.text('Simulador de investimentos'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('investimento1_capital')),
          )
          .controller!
          .text,
      isEmpty,
    );
  });
}
