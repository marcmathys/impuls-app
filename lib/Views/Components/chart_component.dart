import 'dart:async';

import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/bluetooth_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries<MedicalData, String>>[
        LineSeries<MedicalData, String>(
          name: 'EKG',
          dataSource: BluetoothHandler().ekgPoints,
          xValueMapper: (MedicalData medicalData, _) => medicalData.dateTime.millisecond.toString(),
          yValueMapper: (MedicalData medicalData, _) => medicalData.ekgPoint.toDouble(),
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        ),
      ],
    );
  }
}
