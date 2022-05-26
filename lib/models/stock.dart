import 'package:tlc/models/base_model.dart';

class Stock extends BaseModel {
  String stock;
  List<dynamic> open = [];
  List<dynamic> closed = [];
  String? currency;

  Stock(Json json)
      : stock = json['stock'],
        open = json['open'],
        closed = json['closed'],
        currency = json['currency'],
        super(json);

  @override
  String toString() => Format().row(
      [
        portfolio,
        stock,
        moneyFormat.format(proceeds),
        moneyFormat.format(commission),
        moneyFormat.format(cash),
        moneyFormat.format(risk),
        quantity.toString().padLeft(10),
        open.length.toString().padLeft(10),
        closed.length.toString().padLeft(10)
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
      ],
      delimiter: '  |  ',
      widths: [20, 20, 20, 20, 20, 20, 10, 10, 10]);

  @override
  String get header => Format().row(
      [
        'PORT',
        'STOCK',
        'PROCEEDS',
        'COMMISSION',
        'CASH',
        'RISK',
        '  QUANTITY',
        '    OPEN',
        'CLOSED',
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
      ],
      delimiter: '  |  ',
      widths: [20, 20, 20, 20, 20, 20, 10, 10, 10]);

  @override
  Json toJson() => {
        '_id': id,
        'portfolio': portfolio,
        'stock': stock,
        'open': open,
        'closed': closed,
        'proceeds': proceeds,
        'commission': commission,
        'cash': cash,
        'risk': risk,
        'currency': currency,
        'quantity': quantity
      };
}
