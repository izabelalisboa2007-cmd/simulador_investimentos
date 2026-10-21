# Simulador de investimentos

Aplicativo Flutter para comparar a evolução de dois investimentos com capital
inicial, aplicação mensal e taxa de juros próprios. O período, informado em
meses, é compartilhado pelos dois.

## Funcionalidades

- Formulário com validação dos valores e do período (de 1 a 600 meses).
- Cálculo de juros compostos e aportes mensais para cada investimento.
- Resumo comparativo com montante final e rendimento acumulado.
- Lista comparativa com os saldos inicial e de cada mês.
- Ação para voltar e editar os dados ou iniciar uma nova comparação.

## Regra de cálculo

Os juros de cada mês incidem sobre o saldo existente no início do mês. A
aplicação mensal é adicionada ao final do mês e começa a render no mês seguinte:

```text
saldo do mês = saldo anterior × (1 + taxa mensal) + aplicação mensal
```

O rendimento total é o montante final menos o capital inicial e a soma de todas
as aplicações mensais. A taxa deve ser informada em porcentagem ao mês (por
exemplo, `1` para `1%`).

## Executar

Na pasta `simulador_investimento`, execute:

```bash
flutter pub get
flutter run
```

Para executar os testes:

```bash
flutter test
```

## Demonstração em vídeo

Para gravar a demonstração, preencha os dados dos dois investimentos, compare
os montantes e rendimentos, percorra a evolução mensal e use **Nova comparação**
para mostrar como reiniciar a simulação.
