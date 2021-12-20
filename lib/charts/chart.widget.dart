import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AppTimeSeriesChart extends StatelessWidget {
  final List<charts.Series<TimeSeriesData, DateTime>> seriesList;
  final bool animate;

  AppTimeSeriesChart(this.seriesList, {required Key key, required this.animate})
      : super(key: key);

  factory AppTimeSeriesChart.withSampleData() {
    return AppTimeSeriesChart(
      _createSampleData(),
      key: Key('time-series-chart'),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(seriesList,
        animate: animate,
        // Optionally pass in a [DateTimeFactory] used by the chart. The factory
        // should create the same type of [DateTime] as the data provided. If none
        // specified, the default creates local date time.
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec:
                charts.BasicNumericTickProviderSpec(zeroBound: false)));
  }

  static List<charts.Series<TimeSeriesData, DateTime>> _createSampleData() {
    final List<TimeSeriesData> data = <TimeSeriesData>[
      TimeSeriesData(DateTime(2017, 9, 19), 5),
      TimeSeriesData(DateTime(2017, 9, 26), 25),
      TimeSeriesData(DateTime(2017, 10, 3), 100),
      TimeSeriesData(DateTime(2017, 10, 10), 75),
    ];

    return <charts.Series<TimeSeriesData, DateTime>>[
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Data',
        colorFn: (TimeSeriesData _, int? __) =>
            charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData values, int? _) => values.time,
        measureFn: (TimeSeriesData values, int? _) => values.value,
        data: data,
      )
    ];
  }
}

class TimeSeriesData {
  final DateTime time;
  final int value;

  TimeSeriesData(this.time, this.value);
}
