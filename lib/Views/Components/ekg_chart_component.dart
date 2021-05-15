import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/States/ekg_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EKGChart extends StatefulWidget {
  EKGChartState createState() => EKGChartState();
}

class EKGChartState extends State<EKGChart> {
  // ignore: unused_field
  ChartSeriesController _controller;

  @override
  void initState() {
    super.initState();
    context.read(ekgServiceProvider.notifier).startDataStreams();
  }

  @override
  void dispose() {
    context.read(ekgServiceProvider.notifier).sendOffSignal();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        List<MedicalData> data = watch(ekgServiceProvider);

        return SfCartesianChart(
          legend: Legend(isVisible: true),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<MedicalData, num>>[
            LineSeries<MedicalData, num>(
              dataSource: data,
              onRendererCreated: (ChartSeriesController controller) => _controller = controller,
              name: 'EKG',
              xValueMapper: (MedicalData medicalData, _) => medicalData.xAxis,
              yValueMapper: (MedicalData medicalData, _) => medicalData.ekgPoint,
              animationDuration: 0,
              dataLabelSettings: DataLabelSettings(isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
            ),
          ],
        );
      },
    );
  }
}
