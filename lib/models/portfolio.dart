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
        proceeds.toStringAsFixed(2),
        commission.toStringAsFixed(2),
        cash.toStringAsFixed(2),
        risk.toStringAsFixed(2),
        quantity.toString().padLeft(10),
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
        TableAlignment.middle,
      ],
      delimiter: '  |  ',
      widths: [20, 20, 20, 20, 20, 20, 20, 20]);

  @override
  String get header => Format().row(
      [
        'PORT',
        'PROCEEDS',
        'COMMISSION',
        'CASH',
        'RISK',
        '  QUANTITY',
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
        TableAlignment.middle,
      ],
      delimiter: '  |  ',
      widths: [20, 20, 20, 20, 20, 20, 20, 20]);

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
