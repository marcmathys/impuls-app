import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PainLevelChart extends StatelessWidget {
  Widget build(BuildContext context) {
    return SfCartesianChart(primaryXAxis: CategoryAxis(labelRotation: 90), series: <ColumnSeries<MockData, int>>[
      ColumnSeries<MockData, int>(
        // Bind data source
        dataSource: <MockData>[
          MockData(1, 10),
          MockData(2, 8),
          MockData(3, 6),
          MockData(4, 4),
        ],
        xValueMapper: (MockData mock, _) => mock.session,
        yValueMapper: (MockData mock, _) => mock.level,
      )
    ]);
  }
}

class MockData {
  int session;
  int level;

  MockData(this.session, this.level);
}
