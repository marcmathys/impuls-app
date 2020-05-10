import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key key,
    @required List<MedicalData> chartData,
  })  : _chartData = chartData,
        super(key: key);

  final List<MedicalData> _chartData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      zoomPanBehavior:
          ZoomPanBehavior(enablePinching: true, enablePanning: true),
      primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      series: <ChartSeries<MedicalData, DateTime>>[
        LineSeries<MedicalData, DateTime>(
          name: 'EKG',
          dataSource: _chartData,
          xValueMapper: (MedicalData medicalData, _) => medicalData.dateTime,
          yValueMapper: (MedicalData medicalData, _) => medicalData.ekgHigh,
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(
              isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        ),
      ],
    );
  }
}

class MedicalData {
  MedicalData(this.dateTime, this.ekgHigh);

  final DateTime dateTime;
  final num ekgHigh;
}
