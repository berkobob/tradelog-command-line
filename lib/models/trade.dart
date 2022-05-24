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
  String toString() => Format().row(
      [
        date.toString(),
        bos,
        asset.padLeft(4),
        symbol,
        quantity.toString(),
        strike?.toStringAsFixed(2) ?? '',
        expiry?.toString() ?? '',
        poc?.padLeft(2),
        price.toStringAsFixed(2),
        proceeds.toStringAsFixed(2),
        commission.toStringAsFixed(2),
        cash.toStringAsFixed(2),
        risk.toStringAsFixed(2),
        multiplier.toString(),
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
      ],
      delimiter: '  |  ',
      widths: [10, 5, 5, 20, 5, 10, 10, 5, 10, 10, 10, 10, 10, 5]);

  @override
  String get header => Format().row(
      [
        'DATE',
        'BOS',
        'ASSET',
        'SYMBOL',
        'QTY',
        'STRIKE',
        'EXPIRY',
        'POC',
        'PRICE',
        'PROCEEDS',
        'COMMISSION',
        'CASH',
        'RISK',
        'MULT',
      ],
      alignments: [
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.left,
        TableAlignment.left,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right,
        TableAlignment.right
      ],
      delimiter: '  |  ',
      widths: [10, 5, 5, 20, 5, 10, 10, 5, 10, 10, 10, 10, 10, 5]);

  Json toJson() => {
        '_id': id,
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
}
