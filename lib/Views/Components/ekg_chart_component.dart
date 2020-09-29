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
  int updateCounter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateList(List<int> bluetoothData) {
    ByteData ekgByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    int ekgPoint = ekgByteData.getInt16(0, Endian.big);
    _ekgPoints.add(MedicalData(ekgPoint, currentIndex));
    currentIndex++;
    updateCounter++;

    if (updateCounter >= AppConstants.EKG_LIST_UPDATE_THRESHOLD) {
      if (_ekgPoints.length >= AppConstants.EKG_LIST_LIMIT + AppConstants.EKG_LIST_UPDATE_THRESHOLD) {
         _ekgPoints = []; currentIndex = 0; //TODO: Quick and dirty fix. Replace with: _ekgPoints.removeRange(0, 10);
        _controller.updateDataSource(
          addedDataIndexes: List<int>.generate(AppConstants.EKG_LIST_UPDATE_THRESHOLD, (index) => AppConstants.EKG_LIST_LIMIT + index + 1),
          removedDataIndexes: List<int>.generate(AppConstants.EKG_LIST_UPDATE_THRESHOLD, (index) => index),
        );
      } else {
        _controller.updateDataSource(
          addedDataIndexes: <int>[_ekgPoints.length - 1], //TODO: Only updates the last instead of the last 10 points
        );
      }
      updateCounter = 0;
    }
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
          onRendererCreated: (ChartSeriesController controller) => _controller = controller,
          name: 'EKG',
          dataSource: _ekgPoints,
          xValueMapper: (MedicalData medicalData, _) => medicalData.xAxis,
          yValueMapper: (MedicalData medicalData, _) => medicalData.ekgPoint,
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        ),
      ],
    );
  }
}
