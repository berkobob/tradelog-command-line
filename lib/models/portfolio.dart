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

  // @override
  // String toString() => '${portfolio.padLeft(12)}\t'
  //     '${moneyFormat.format(proceeds).padLeft(12)}\t'
  //     '${moneyFormat.format(commission).padLeft(12)}\t'
  //     '${moneyFormat.format(cash).padLeft(12)}\t'
  //     '${moneyFormat.format(risk).padLeft(12)}\t'
  //     '${stocks.length.toString().padLeft(12)}\t'
  //     '${moneyFormat.format(profit).padLeft(12)}\t'
  //     '${currency?.padLeft(12) ?? ""}\t';

  // @override
  // String get header => black(
  //     '${'PORT'.padLeft(12)}\t'
  //     '${'PROCEEDS'.padLeft(12)}\t'
  //     '${'COMMISSION'.padLeft(12)}\t'
  //     '${'CASH'.padLeft(12)}\t'
  //     '${'RISK'.padLeft(12)}\t'
  //     '${'STOCKS'.padLeft(12)}\t'
  //     '${' PROFIT'.padLeft(12)}\t'
  //     '${' CURRENCY'.padLeft(12)}',
  //     background: AnsiColor.white);

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
      };

  @override
  int compareTo(BaseModel other) =>
      portfolio.compareTo((other as Portfolio).portfolio);
}
