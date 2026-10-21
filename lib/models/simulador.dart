class Investimento {
  const Investimento({
    required this.nome,
    required this.capitalInicial,
    required this.aporteMensal,
    required this.taxaMensalPercentual,
  });

  final String nome;
  final double capitalInicial;
  final double aporteMensal;
  final double taxaMensalPercentual;

  Simulacao simular(int periodoEmMeses) {
    final taxaMensal = taxaMensalPercentual / 100;
    var saldo = capitalInicial;
    final evolucao = <double>[saldo];

    for (var mes = 1; mes <= periodoEmMeses; mes++) {
      saldo = saldo * (1 + taxaMensal) + aporteMensal;
      evolucao.add(saldo);
    }

    return Simulacao(
      investimento: this,
      evolucaoMensal: List.unmodifiable(evolucao),
    );
  }
}

class Simulacao {
  const Simulacao({required this.investimento, required this.evolucaoMensal});

  final Investimento investimento;
  final List<double> evolucaoMensal;

  double get montanteFinal => evolucaoMensal.last;

  double get totalInvestido =>
      investimento.capitalInicial +
      investimento.aporteMensal * (evolucaoMensal.length - 1);

  double get rendimentoTotal => montanteFinal - totalInvestido;
}
