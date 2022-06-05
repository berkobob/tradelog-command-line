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
  Json toJson() => {
        'id': id,
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

  @override
  int compareTo(BaseModel other) =>
      symbol.compareTo((other as Position).symbol);
}
