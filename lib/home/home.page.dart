import 'dart:collection';
import 'dart:core';
import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/error/error.widget.dart';
import 'package:flutter_starter/loading/loading.widget.dart';
import 'package:http/http.dart' as http;

class CurrencyRate {
  final double last15m;
  final double last;
  final double buy;
  final double sell;
  final String symbol;

  CurrencyRate(
      {required this.last15m,
      required this.last,
      required this.buy,
      required this.sell,
      required this.symbol});
}

class ApiResponse {
  final String body;
  final List<CurrencyRate> data;

  ApiResponse({required this.body, required this.data});

  factory ApiResponse.fromJson(String body) {
    Map<String, dynamic> jsonData = jsonDecode(body) as Map<String, dynamic>;
    List<CurrencyRate> data = jsonData.values
        .map<CurrencyRate>((dynamic value) => CurrencyRate(
            last15m: value['15m'] as double,
            last: value['last'] as double,
            buy: value['buy'] as double,
            sell: value['sell'] as double,
            symbol: value['symbol'] as String))
        .toList();
    ApiResponse result = ApiResponse(body: body, data: data);
    return result;
  }
}

class AppHomePage extends StatefulWidget {
  const AppHomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  final Stream<User?> _authChange = FirebaseAuth.instance.authStateChanges();

  StreamSubscription<User?>? _userSub;

  User? _user;

  void _showSnackbar(String message) {
    Text text = Text(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: text),
    );
  }

  void _refreshData() {
    setState(() {
      _getData();
    });
  }

  List<CurrencyRate> tableData = <CurrencyRate>[];

  Future<ApiResponse> _getDataFuture() {
    Uri uri = Uri.parse('https://blockchain.info/ticker');

    Map<String, String> headers = HashMap<String, String>();
    headers.putIfAbsent('Accept', () => 'application/json');
    headers.putIfAbsent(
        'Content-Type', () => 'application/json; charset=UTF-8');

    return http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10))
        .then((http.Response response) => ApiResponse.fromJson(response.body))
        .catchError((Object error) {
      String errorText = 'Get data failed. $error';
      Exception exception = Exception(errorText);
      _showSnackbar(errorText);
      throw exception;
    });
  }

  Future<ApiResponse> _getData() async {
    final ApiResponse responseData = await _getDataFuture();
    tableData = responseData.data;
    return responseData;
  }

  Expanded _tableBody(BuildContext ctx) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            dataRowHeight: 50,
            dividerThickness: 2,
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  "Symbol",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrange,
                  ),
                ),
                numeric: false,
                tooltip: "Currency symbol",
              ),
              DataColumn(
                label: Text(
                  "15 m",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrange,
                  ),
                ),
                numeric: true,
                tooltip: "The last 15 m change",
              ),
              DataColumn(
                label: Text(
                  "Last",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrange,
                  ),
                ),
                numeric: true,
                tooltip: "The last change",
              ),
              DataColumn(
                label: Text(
                  "Buy",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrange,
                  ),
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  "Sell",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrange,
                  ),
                ),
                numeric: true,
              ),
            ],
            rows: tableData.map<DataRow>((CurrencyRate item) {
              return DataRow(cells: <DataCell>[
                DataCell(
                  Text(item.symbol),
                ),
                DataCell(
                  Text('${item.last15m}'),
                ),
                DataCell(
                  Text('${item.last}'),
                ),
                DataCell(
                  Text('${item.buy}'),
                ),
                DataCell(
                  Text('${item.sell}'),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    _userSub = _authChange.listen((User? user) {
      if (user == null) {
        _showSnackbar('User is currently signed out!');
        Navigator.pushNamed(context, '/login');
        setState(() {
          _user = null;
        });
      } else {
        _showSnackbar('User is signed in!');
        setState(() {
          _user = user;
          _getData();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () => Navigator.pushNamed(context, '/about')),
          if (_user == null)
            IconButton(
                icon: Icon(Icons.login),
                onPressed: () => Navigator.pushNamed(context, '/login')),
          if (_user != null)
            IconButton(
                icon: Icon(Icons.bar_chart),
                onPressed: () => Navigator.pushNamed(context, '/charts')),
          if (_user != null)
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => FirebaseAuth.instance.signOut()),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Logged in user: ${_user?.email}',
            ),
            Text(
              'Exchange rates',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            FutureBuilder<ApiResponse>(
              future: _getDataFuture(),
              builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
                if (snapshot.hasError) {
                  return AppErrorWidget(
                    key: Key('error.widget'),
                    snapshot: snapshot,
                  );
                }

                // Once complete, show your application
                if (snapshot.connectionState == ConnectionState.done) {
                  return _tableBody(context);
                }

                // Otherwise, show something whilst waiting for initialization to complete
                return AppLoadingWidget(key: Key('loading'));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        tooltip: 'Refresh data',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
