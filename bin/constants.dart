const root = 'http://localhost';
const port = '8888';
const headers = {'Content-Type': 'application/json'};

enum Url {
  home('$root:$port/'),
  trades('$root:$port/trades'),
  positions('$root:$port/positions'),
  stocks('$root:$port/stocks'),
  portfolios('$root:$port/portfolios');

  const Url(this.url);

  final String url;

  Uri get uri => Uri.parse(url);
}

typedef Json = Map<String, dynamic>;
