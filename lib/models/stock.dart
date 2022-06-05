import 'package:tlc/models/base_model.dart';

class Stock extends BaseModel {
  String stock;
  List<dynamic> open = [];
  List<dynamic> closed = [];
  String? currency;
  num profit;
  num dividends;

  Stock(Json json)
      : stock = json['stock'],
        open = json['open'],
        closed = json['closed'],
        currency = json['currency'],
        profit = json['profit'],
        dividends = json['dividends'],
        super(json);

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
        'quantity': quantity,
        'profit': profit,
        'dividends': dividends,
      };

  @override
  int compareTo(BaseModel other) => stock.compareTo((other as Stock).stock);
}
