import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PainLevelChart extends StatefulWidget {
  final int initialLevel;
  final int finalLevel;

  PainLevelChart(this.initialLevel, this.finalLevel);

  @override
  _PainLevelChartState createState() => _PainLevelChartState();
}

class _PainLevelChartState extends State<PainLevelChart> {
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Thresholds', textStyle: TextStyle(fontWeight: FontWeight.bold)),
      primaryXAxis: CategoryAxis(),
      series: <ColumnSeries>[
        ColumnSeries<num, String>(
          dataSource: [widget.initialLevel, widget.finalLevel],
          xValueMapper: (_, index) {
            return index == 0 ? 'Initial Level' : 'Final Level';
          },
          yValueMapper: (num level, _) => level,
        )
      ],
    );
  }
}
