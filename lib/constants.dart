import 'package:intl/intl.dart';

const root = 'http://localhost';
const port = '8888';
const headers = {'Content-Type': 'application/json'};

enum Url {
  home(''),
  trades('trades'),
  positions('positions'),
  stocks('stocks'),
  portfolios('portfolios');

  const Url(this.name);

  final String name;

  Uri get uri => Uri.parse('$root:$port/$name');

  List get all => Url.values.map((x) => {x.name: x.uri}).toList();
}

typedef Json = Map<String, dynamic>;

final urls = <String, Uri>{
  Url.home.name: Url.home.uri,
  Url.trades.name: Url.trades.uri,
  Url.positions.name: Url.positions.uri,
  Url.stocks.name: Url.stocks.uri,
  Url.portfolios.name: Url.portfolios.uri,
};

final DateFormat date = DateFormat('dd/MM/yyyy');

final moneyFormat = NumberFormat.currency(customPattern: "#,##0.00");
