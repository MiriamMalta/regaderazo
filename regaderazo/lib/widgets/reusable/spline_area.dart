import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/slean.dart';

class SplineArea extends StatefulWidget {
  SplineArea({
    Key? key,
    required List<SplineAreaData> data,
    required Color colorA,
    required Color colorB,
  }) : _data = data, _colorA = colorA, _colorB = colorB, super(key: key);

  late List<SplineAreaData> _data;
  late Color _colorA;
  late Color _colorB;

  @override
  State<SplineArea> createState() => _SplineAreaState();
}

class _SplineAreaState extends State<SplineArea> {
  _SplineAreaState();
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(
        isVisible: true, 
        opacity: 0.7,
        position: LegendPosition.bottom,
      ),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value} L',
        axisLine: AxisLine(width: 1),
        //majorTickLines: MajorTickLines(size: 0)
      ),
      series: _getSplieAreaSeries(),
      tooltipBehavior: _tooltip,
    );
  }

  List<ChartSeries<SplineAreaData, String>> _getSplieAreaSeries() {
    return <ChartSeries<SplineAreaData, String>>[
      SplineAreaSeries<SplineAreaData, String>(
        dataSource: widget._data,
        color: widget._colorB.withOpacity(0.6),
        borderColor: widget._colorB,
        borderWidth: 1,
        name: 'Total Litros',
        xValueMapper: (SplineAreaData sales, _) => sales.day,
        yValueMapper: (SplineAreaData sales, _) => sales.y2,
      ),
      SplineAreaSeries<SplineAreaData, String>(
        dataSource: widget._data,
        color: widget._colorA,
        borderColor: widget._colorA,
        borderWidth: 1,
        name: 'Ahorro Litros',
        xValueMapper: (SplineAreaData sales, _) => sales.day,
        yValueMapper: (SplineAreaData sales, _) => sales.y1,
      ),
    ];
  }

  @override
  void dispose() {
    widget._data.clear();
    super.dispose();
  }

}

