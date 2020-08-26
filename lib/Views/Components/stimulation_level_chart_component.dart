import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StimulationLevelChart extends StatefulWidget {
  @override
  _StimulationLevelChartState createState() => _StimulationLevelChartState();
}

class _StimulationLevelChartState extends State<StimulationLevelChart> {
  Widget build(BuildContext context) {
    return SfCartesianChart(primaryXAxis: CategoryAxis(labelRotation: 90), series: <ColumnSeries<MockData, int>>[
      ColumnSeries<MockData, int>(
        // Bind data source
        dataSource: <MockData>[
          MockData(1, 200),
          MockData(2, 800),
          MockData(3, 1400),
          MockData(4, 2000),
        ],
        xValueMapper: (MockData mock, _) => mock.session,
        yValueMapper: (MockData mock, _) => mock.threshold,
      )
    ]);
  }
}

class MockData {
  int session;
  int threshold;

  MockData(this.session, this.threshold);
}
