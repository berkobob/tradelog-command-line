import 'package:tlc/models/base_model.dart';

class Dividend extends BaseModel {
  DateTime date;
  String symbol;
  String description;

  Dividend(Json json)
      : date = DateTime.parse(json['date']),
        symbol = json['symbol'],
        description = json['description'],
        super(json);

  @override
  String toString() => Format().row(
      [
        portfolio,
        date.toString(),
        symbol,
        description,
        moneyFormat.format(proceeds),
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
      ],
      delimiter: '|',
      widths: [10, 10, 10, 45, 15]);

  @override
  String get header =>
      Format().row(['PORTFOLIO', 'DATE', 'SYMBOL', 'DESCRIPTION', 'AMOUNT'],
          alignments: [
            TableAlignment.left,
            TableAlignment.left,
            TableAlignment.left,
            TableAlignment.left,
            TableAlignment.right,
          ],
          delimiter: '|',
          widths: [10, 10, 10, 45, 15]);

  @override
  Json toJson() => {
        'portfolio': portfolio,
        'date': date.toString(),
        'symbol': symbol,
        'description': description,
        'proceeds': proceeds
      };
}
