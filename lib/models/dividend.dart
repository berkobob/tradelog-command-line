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
  Json toJson() => {
        'id': id,
        'portfolio': portfolio,
        'date': date.toString(),
        'symbol': symbol,
        'description': description,
        'proceeds': proceeds
      };

  @override
  int compareTo(BaseModel other) => date.compareTo((other as Dividend).date);
}
