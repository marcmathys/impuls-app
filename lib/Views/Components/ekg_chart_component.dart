import 'dart:async';

import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Displays a Chart widget. Mode can be either EKG or IBI.
class EKGChart extends StatefulWidget {
  _EKGChartState createState() => _EKGChartState();
}

class _EKGChartState extends State<EKGChart> {
  Timer _timer;
  BTState _state;

  @override
  void initState() {
    super.initState();
    _state = BTState();
    _timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      primaryYAxis: CategoryAxis(),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries<MedicalData, String>>[
        LineSeries<MedicalData, String>(
          name: 'EKG',
          dataSource: _state.ekgPoints,
          xValueMapper: (MedicalData medicalData, _) => medicalData.xAxis.toString(),
          yValueMapper: (MedicalData medicalData, _) => medicalData.ekgPoint.toDouble(),
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        ),
      ],
    );
  }
}
