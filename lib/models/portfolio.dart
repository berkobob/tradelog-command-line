import 'package:tlc/models/base_model.dart';

class Portfolio extends BaseModel {
  Set<dynamic> stocks = {};
  String? currency;
  num profit;
  num dividends;

  Portfolio(Json json)
      : stocks = json['stocks'].toSet(),
        currency = json['currency'],
        profit = json['profit'],
        dividends = json['dividends'],
        super(json);

  @override
  Json toJson() => {
        'id': id,
        'portfolio': portfolio,
        'stocks': stocks.toList(),
        'proceeds': proceeds,
        'commission': commission,
        'cash': cash,
        'risk': risk,
        'currency': currency,
        'quantity': quantity,
        'profit': profit,
        'dividends': dividends,
      };

  @override
  int compareTo(BaseModel other) =>
      portfolio.compareTo((other as Portfolio).portfolio);
}
