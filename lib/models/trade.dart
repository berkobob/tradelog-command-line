import 'package:tlc/models/base_model.dart';

class Trade extends BaseModel {
  DateTime date;
  String bos;
  String symbol;
  String stock;
  DateTime? expiry;
  double? strike;
  String? poc;
  double price;
  String asset;
  String? ooc;
  int multiplier;
  String? notes;
  String? tradeid;
  String? currency;
  double? fx;
  String description;

  Trade(Json json)
      : date = DateTime.parse(json['date']),
        bos = json['bos'],
        symbol = json['symbol'],
        stock = json['stock'],
        expiry = json['expiry'] != null ? DateTime.parse(json['expiry']) : null,
        strike = json['strike'],
        poc = json['poc'],
        price = json['price'],
        asset = json['asset'],
        ooc = json['ooc'],
        multiplier = json['multiplier'],
        notes = json['notes'],
        tradeid = json['tradeid'],
        currency = json['currency'],
        fx = json['fx'],
        description = json['description'],
        super(json);

  @override
  Json toJson() => {
        'id': id,
        'date': date.toString(),
        'bos': bos,
        'quantity': quantity,
        'symbol': symbol,
        'stock': stock,
        'expiry': expiry?.toString(),
        'strike': strike,
        'poc': poc,
        'price': price,
        'proceeds': proceeds,
        'commission': commission,
        'cash': cash,
        'asset': asset,
        'ooc': ooc,
        'multiplier': multiplier,
        'notes': notes,
        'tradeid': tradeid,
        'currency': currency,
        'fx': fx,
        'portfolio': portfolio,
        'description': description,
        'risk': risk
      };

  @override
  int compareTo(BaseModel other) => date.compareTo((other as Trade).date);
}
