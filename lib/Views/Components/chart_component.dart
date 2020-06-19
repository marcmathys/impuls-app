import 'dart:async';

import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/ibi_point.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/bluetooth_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Displays a Chart widget. Mode can be either EKG or IBI.
class Chart extends StatefulWidget {
  final String _mode;

  const Chart(this._mode);

  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Timer _timer;
  BluetoothHandler _handler;

  @override
  void initState() {
    super.initState();
    _handler = BluetoothHandler();
    _timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  SfCartesianChart ekgChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries<MedicalData, String>>[
        LineSeries<MedicalData, String>(
          name: 'EKG',
          dataSource: _handler.ekgPoints,
          xValueMapper: (MedicalData medicalData, _) => medicalData.xAxis.toString(),
          yValueMapper: (MedicalData medicalData, _) => medicalData.ekgPoint.toDouble(),
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        ),
      ],
    );
  }

  SfCartesianChart ibiChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries<IbiPoint, String>>[
        LineSeries<IbiPoint, String>(
          name: 'IBI',
          dataSource: _handler.ibiPoints,
          xValueMapper: (IbiPoint ibiPoint, _) => ibiPoint.xAxis.toString(),
          yValueMapper: (IbiPoint ibiPoint, _) => ibiPoint.ibiPoint.toDouble(),
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    switch (widget._mode) {
      case 'EKG':
        return ekgChart();
        break;
      case 'IBI':
        return ibiChart();
        break;
      default:
        return Container();
    }
  }
}
