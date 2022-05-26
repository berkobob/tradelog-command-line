import 'base_model.dart';

class Position extends BaseModel {
  String stock;
  String symbol;
  String description;
  String? currency;
  DateTime open;
  DateTime? closed;
  List<dynamic> trades = [];
  int? days;

  Position(Json json)
      : stock = json['stock'],
        symbol = json['symbol'],
        description = json['description'],
        currency = json['currency'],
        open = DateTime.parse(json['open']),
        closed = json['closed'] != null ? DateTime.parse(json['closed']) : null,
        trades = json['trades'],
        days = json['days'],
        super(json);

  @override
  String toString() => Format().row(
      [
        portfolio,
        stock,
        description,
        moneyFormat.format(proceeds), //.toStringAsFixed(2),
        moneyFormat.format(commission), //.toStringAsFixed(2),
        moneyFormat.format(cash), //.toStringAsFixed(2),
        moneyFormat.format(risk), //.toStringAsFixed(2),
        quantity.toString().padLeft(10),
        open.toString(),
        closed?.toString() ?? '',
        days?.toString() ?? '',
        trades.length.toString()
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
      ],
      delimiter: '  |  ',
      widths: [10, 10, 20, 20, 20, 20, 20, 10, 10, 10, 10, 10]);

  @override
  String get header => Format().row(
      [
        'PORT',
        'STOCK',
        'DESCRIPTION',
        'PROCEEDS',
        'COMMISSION',
        'CASH',
        'RISK',
        '  QUANTITY',
        '   OPEN',
        '   CLOSED',
        'DAYS',
        '#TRADES'
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
      ],
      delimiter: '  |  ',
      widths: [10, 10, 20, 20, 20, 20, 20, 10, 10, 10, 10, 10]);

  @override
  Json toJson() => {
        '_id': id,
        'portfolio': portfolio,
        'stock': stock,
        'symbol': symbol,
        'description': description,
        'quantity': quantity,
        'proceeds': proceeds,
        'commission': commission,
        'cash': cash,
        'currency': currency,
        'risk': risk,
        'open': open.toString(),
        'closed': closed.toString(),
        'trades': trades,
        'days': days,
      };
}
