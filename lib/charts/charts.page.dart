import 'dart:collection';
import 'dart:core';
import 'dart:async';
import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/charts/chart.widget.dart';
import 'package:flutter_starter/error/error.widget.dart';
import 'package:flutter_starter/loading/loading.widget.dart';
import 'package:http/http.dart' as http;

class ResponseDataValues {
  final int x;
  final double y;

  ResponseDataValues({required this.x, required this.y});
}

class ResponseData {
  final String status;
  final String name;
  final String unit;
  final String period;
  final String description;
  final List<ResponseDataValues> values;

  ResponseData(
      {required this.status,
      required this.name,
      required this.unit,
      required this.period,
      required this.description,
      required this.values});
}

class ApiResponse {
  final String body;
  final ResponseData data;

  ApiResponse({required this.body, required this.data});

  factory ApiResponse.fromJson(String body) {
    Map<String, dynamic> jsonData = jsonDecode(body) as Map<String, dynamic>;
    String status = jsonData['status'] as String;
    String name = jsonData['name'] as String;
    String unit = jsonData['unit'] as String;
    String period = jsonData['period'] as String;
    String description = jsonData['description'] as String;
    List<dynamic> values = jsonData['values'] as List<dynamic>;
    ResponseData data = ResponseData(
        status: status,
        name: name,
        unit: unit,
        period: period,
        description: description,
        values: values
            .map<ResponseDataValues>((dynamic e) =>
                ResponseDataValues(x: e['x'] as int, y: e['y'] as double))
            .toList());
    ApiResponse result = ApiResponse(body: body, data: data);
    return result;
  }
}

class AppChartsPage extends StatefulWidget {
  const AppChartsPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<AppChartsPage> createState() => _AppChartsPageState();
}

class _AppChartsPageState extends State<AppChartsPage> {
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

  ResponseData tableData = ResponseData(
      status: '',
      name: '',
      unit: '',
      period: '',
      description: '',
      values: <ResponseDataValues>[]);

  Future<ApiResponse> _getDataFuture() {
    Uri uri = Uri.parse(
        'https://api.blockchain.info/charts/transactions-per-second?timespan=5weeks&rollingAverage=8hours&format=json');

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

  Expanded _chartsBody(BuildContext ctx) {
    final List<TimeSeriesData> timeSeriesData = tableData.values
        .map((ResponseDataValues e) => TimeSeriesData(
            DateTime.fromMillisecondsSinceEpoch(e.x), e.y.ceil()))
        .toList();
    final List<charts.Series<TimeSeriesData, DateTime>> chartData =
        <charts.Series<TimeSeriesData, DateTime>>[
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Data',
        colorFn: (TimeSeriesData _, int? __) =>
            charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData values, int? _) => values.time,
        measureFn: (TimeSeriesData values, int? _) => values.value,
        data: timeSeriesData,
      )
    ];
    return Expanded(
      child: AppTimeSeriesChart(chartData,
          key: Key('time-series-chart-widget'), animate: false),
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
              'Transactions per second',
              style: Theme.of(context).textTheme.headline5,
            ),
            FutureBuilder<ApiResponse>(
              future: _getDataFuture(),
              builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
                if (snapshot.hasError) {
                  return AppErrorWidget(key: Key('error'), snapshot: snapshot);
                }

                // Once complete, show your application
                if (snapshot.connectionState == ConnectionState.done) {
                  return _chartsBody(context);
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
