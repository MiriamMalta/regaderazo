import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/temperature.dart';

class ColumnChart extends StatefulWidget {
  ColumnChart({
    Key? key,
    required List<TemperatureChart> data,
    required Color color,
  }) : _data = data, _color = color, super(key: key);

  late List<TemperatureChart> _data;
  late Color _color;

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
      tooltipBehavior: _tooltip,
      series: <ChartSeries<TemperatureChart, String>>[
        ColumnSeries<TemperatureChart, String>(
          dataSource: widget._data,
          xValueMapper: (TemperatureChart data, _) => data.x,
          yValueMapper: (TemperatureChart data, _) => data.y,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5)
          ),
          width: 0.8,
          spacing: 0.2,
          name: 'Gold',
          //pointColorMapper: (TemperatureChart data, _) => data.color,
          color: widget._color,
        )
      ]
    );
  }
}

