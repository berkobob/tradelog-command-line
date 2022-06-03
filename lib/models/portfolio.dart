import 'package:tlc/models/base_model.dart';

class Portfolio extends BaseModel {
  Set<dynamic> stocks = {};
  String? currency;
  num profit;

  Portfolio(Json json)
      : stocks = json['stocks'].toSet(),
        currency = json['currency'],
        profit = json['profit'],
        super(json);

  @override
  String toString() => Format().row(
      [
        portfolio,
        moneyFormat.format(proceeds),
        moneyFormat.format(commission),
        moneyFormat.format(cash),
        moneyFormat.format(risk),
        stocks.length.toString().padLeft(15),
        moneyFormat.format(profit),
        currency,
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.middle,
      ],
      delimiter: '  |  ',
      widths: [15, 15, 15, 15, 15, 15, 15, 15]);

  @override
  String get header => Format().row(
      [
        'PORT',
        'PROCEEDS',
        'COMMISSION',
        'CASH',
        'RISK',
        '    STOCKS',
        'PROFIT',
        'CURRENCY',
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.middle,
      ],
      delimiter: '  |  ',
      widths: [15, 15, 15, 15, 15, 15, 15, 15]);

  @override
  Json toJson() => {
        '_id': id,
        'portfolio': portfolio,
        'stocks': stocks.toList(),
        'proceeds': proceeds,
        'commission': commission,
        'cash': cash,
        'risk': risk,
        'currency': currency,
        'quantity': quantity,
        'profit': profit,
      };
}
