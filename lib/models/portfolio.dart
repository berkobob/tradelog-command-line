import 'package:tlc/models/base_model.dart';

class Portfolio extends BaseModel {
  Set<dynamic> stocks = {};
  String? currency;

  Portfolio(Json json)
      : stocks = json['stocks'].toSet(),
        currency = json['currency'],
        super(json);

  @override
  String toString() => Format().row(
      [
        portfolio,
        moneyFormat.format(proceeds),
        moneyFormat.format(commission),
        moneyFormat.format(cash),
        moneyFormat.format(risk),
        stocks.length.toString().padLeft(10),
        currency
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.middle,
        TableAlignment.middle,
      ],
      delimiter: '  |  ',
      widths: [20, 20, 20, 20, 20, 20, 20]);

  @override
  String get header => Format().row(
      [
        'PORT',
        'PROCEEDS',
        'COMMISSION',
        'CASH',
        'RISK',
        '    STOCKS',
        'CURRENCY',
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.middle,
        TableAlignment.middle,
      ],
      delimiter: '  |  ',
      widths: [20, 20, 20, 20, 20, 20, 20]);

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
        'quantity': quantity
      };
}
