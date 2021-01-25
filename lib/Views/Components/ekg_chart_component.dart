import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EKGChart extends StatefulWidget {
  const EKGChart({Key key}) : super(key: key);

  EKGChartState createState() => EKGChartState();
}

class EKGChartState extends State<EKGChart> {
  ChartSeriesController _controller;
  List<MedicalData> _ekgPoints = [];
  num currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void updateList(List<int> bluetoothData) {
    ByteData ekgByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    int ekgPoint = ekgByteData.getInt16(0, Endian.big);
    _ekgPoints.add(MedicalData(ekgPoint, currentIndex));
    currentIndex++;

    if (_ekgPoints.length > AppConstants.EKG_LIST_LIMIT) {
      _ekgPoints.removeAt(0);
    }

    setState(() {});

   /** if (updateCounter >= AppConstants.EKG_LIST_UPDATE_THRESHOLD) {
      if (_ekgPoints.length >= AppConstants.EKG_LIST_LIMIT + AppConstants.EKG_LIST_UPDATE_THRESHOLD) {
        _ekgPoints.removeRange(0, 10);
        _controller.updateDataSource(
          addedDataIndexes: List<int>.generate(AppConstants.EKG_LIST_UPDATE_THRESHOLD, (index) => AppConstants.EKG_LIST_LIMIT + index + 1),
          removedDataIndexes: List<int>.generate(AppConstants.EKG_LIST_UPDATE_THRESHOLD, (index) => index),
        );
      } else {
        _controller.updateDataSource(
          addedDataIndexes: List<int>.generate(AppConstants.EKG_LIST_UPDATE_THRESHOLD, (index) => _ekgPoints.length - index),
        );
      }
      updateCounter = 0;
      setState(() {});
    } **/
  }

  void resetEkgPoints() {
    _ekgPoints.clear();
  }

  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      primaryXAxis: NumericAxis(),
      primaryYAxis: NumericAxis(),
      series: <ChartSeries<MedicalData, num>>[
        LineSeries<MedicalData, num>(
          dataSource: _ekgPoints,
          onRendererCreated: (ChartSeriesController controller) => _controller = controller,
          name: 'EKG',
          xValueMapper: (MedicalData medicalData, _) => medicalData.xAxis,
          yValueMapper: (MedicalData medicalData, _) => medicalData.ekgPoint,
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        ),
      ],
    );
  }
}
