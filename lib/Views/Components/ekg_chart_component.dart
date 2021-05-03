import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/States/ekg_state.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EKGChart extends StatefulWidget {
  EKGChartState createState() => EKGChartState();
}

class EKGChartState extends State<EKGChart> {
  // ignore: unused_field
  ChartSeriesController _controller;
  num currentIndex = 0;

  @override
  void initState() {
    super.initState();
    BtService().getEKGAndBPMData(context);
  }

  @override
  void dispose() {
    BtService().sendOffSignal(BtState().characteristics[AppConstants.EKG_CHARACTERISTIC_UUID]);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      primaryXAxis: NumericAxis(),
      primaryYAxis: NumericAxis(),
      series: <ChartSeries<MedicalData, num>>[
        LineSeries<MedicalData, num>(
          dataSource: Provider.of<EkgState>(context).ekgPoints,
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
