import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ThresholdChart extends StatefulWidget {
  final List<int> sensoryThresholds;
  final List<int> painThresholds;
  final List<int> toleranceThreshold;

  ThresholdChart(this.sensoryThresholds, this.painThresholds, this.toleranceThreshold);

  @override
  _ThresholdChartState createState() => _ThresholdChartState();
}

class _ThresholdChartState extends State<ThresholdChart> {
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Pain Levels', textStyle: TextStyle(fontWeight: FontWeight.bold)),
      series: <ChartSeries>[
        StackedLineSeries<int, int>(
            dataSource: widget.sensoryThresholds,
            xValueMapper: (_, index) => index,
            yValueMapper: (int sensory, _) => sensory,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              useSeriesColor: true,
            )),
        StackedLineSeries<int, int>(
          dataSource: widget.painThresholds,
          xValueMapper: (_, index) => index,
          yValueMapper: (int sensory, _) => sensory,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
          ),
          color: Colors.grey,
        ),
        StackedLineSeries<int, int>(
          dataSource: widget.toleranceThreshold,
          xValueMapper: (_, index) => index,
          yValueMapper: (int sensory, _) => sensory,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
          ),
          color: Colors.redAccent,
        ),
      ],
    );
  }
}
