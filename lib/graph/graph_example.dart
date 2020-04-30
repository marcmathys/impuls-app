import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  // Register your license here
  SyncfusionLicense.registerLicense(null);
  return runApp(ChartApp());
}

class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic chartData = [
    MedicalData(DateTime(2017, 1, 7, 18, 19, 32), 0, 0, 0, 108, 0.0, 0, 555, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 33), 0, 0, 0, 93, 0.0, 0, 645, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 34), 0, 0, 0, 59, 0.0, 0, 1015, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 35), 0, 0, 0, 58, 0.0, 0, 1040, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 36), 0, 0, 0, 58, 0.0, 0, 1030, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 37), 0, 0, 0, 59, 0.0, 0, 1015, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 38), 0, 0, 0, 20, 0.0, 0, 3035, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 41), 0, 0, 0, 61, 0.0, 0, 985, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 42), 0, 0, 0, 61, 0.0, 0, 990, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 43), 0, 0, 0, 59, 0.0, 0, 1020, 0,
        0.0, 0.000, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 44), 65, 85, 59, 69.0, 335, 1025,
        533, 4.0, 1.255, 0, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 45), 113, 66, 85, 58, 71.3, 330,
        1030, 533, 4.2, 1.222, 1629),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 46), 111, 65, 84, 60, 72.8, 325,
        1005, 525, 4.3, 1.160, 1547),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 47), 114, 66, 85, 58, 78.5, 340,
        1030, 546, 4.6, 1.109, 1478),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 48), 114, 66, 85, 58, 84.5, 340,
        1040, 550, 4.9, 1.040, 1387),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 49), 115, 66, 85, 57, 85.5, 340,
        1055, 558, 4.9, 1.043, 1390),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 50), 114, 65, 84, 56, 86.5, 345,
        1065, 554, 4.9, 1.034, 1379),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 51), 114, 66, 84, 57, 85.8, 340,
        1045, 546, 4.9, 1.021, 1361),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 52), 65, 83, 59, 83.8, 330, 1020,
        538, 4.9, 1.014, 1352, 0),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 53), 110, 65, 83, 61, 83.8, 330,
        990, 521, 5.1, 0.984, 1312),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 54), 110, 65, 83, 59, 83.8, 330,
        1015, 521, 5.0, 1.009, 1345),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 55), 110, 65, 83, 60, 83.8, 330,
        995, 521, 5.1, 0.989, 1319),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 56), 110, 65, 83, 60, 83.8, 330,
        1000, 521, 5.0, 0.994, 1325),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 57), 120, 70, 89, 60, 71.0, 330,
        1000, 608, 4.3, 1.246, 1662),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 58), 122, 69, 89, 60, 75.5, 335,
        1000, 608, 4.5, 1.175, 1567),
    MedicalData(DateTime(2017, 1, 7, 18, 19, 59), 121, 69, 88, 60, 77.0, 330,
        1000, 608, 4.6, 1.143, 1524),
    MedicalData(DateTime(2017, 1, 7, 18, 20, 00), 118, 68, 87, 61, 80.5, 335,
        980, 617, 4.9, 1.059, 1412),
    MedicalData(DateTime(2017, 1, 7, 18, 20, 01), 117, 68, 86, 60, 82.3, 330,
        995, 592, 5.0, 1.037, 1383),
    MedicalData(DateTime(2017, 1, 7, 18, 20, 02), 117, 67, 87, 60, 86.3, 340,
        1005, 588, 5.1, 1.011, 1348),
    MedicalData(DateTime(2017, 1, 7, 18, 20, 03), 120, 68, 89, 61, 86.3, 330,
        980, 596, 5.3, 1.008, 1345),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
            legend: Legend(isVisible: true),
            zoomPanBehavior:
            ZoomPanBehavior(enablePinching: true, enablePanning: true),
            primaryXAxis: DateTimeAxis(),
            series: <ChartSeries<MedicalData, DateTime>>[
              LineSeries<MedicalData, DateTime>(
                name: 'Systolic Pressure',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.systolicPressure,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Diastolic Pressure',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.diastolicPressure,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Mean Pressure',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.meanPressure,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Heart Rate',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.heartRate,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Stroke Volume',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.strokeVolume,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Left Ventricular',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.leftVentricularEjectionTime,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'pulse Interval',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.pulseInterval,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Maximum Slope',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.maximumSlope,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Cardiac Output',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.cardiacOutput,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Peripheral medical',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.totalPeripheralMedical,
              ),
              LineSeries<MedicalData, DateTime>(
                name: 'Peripheral CGS',
                dataSource: chartData,
                xValueMapper: (MedicalData medicalData, _) =>
                medicalData.dateTime,
                yValueMapper: (MedicalData medicalData, _) =>
                medicalData.totalPeripheralCGS,
              ),
            ]));
  }
}

class MedicalData {
  MedicalData(
      this.dateTime,
      this.systolicPressure,
      this.diastolicPressure,
      this.meanPressure,
      this.heartRate,
      this.strokeVolume,
      this.leftVentricularEjectionTime,
      this.pulseInterval,
      this.maximumSlope,
      this.cardiacOutput,
      this.totalPeripheralMedical,
      this.totalPeripheralCGS);

  final DateTime dateTime;
  final num systolicPressure;
  final num diastolicPressure;
  final num meanPressure;
  final num heartRate;
  final num strokeVolume;
  final num leftVentricularEjectionTime;
  final num pulseInterval;
  final num maximumSlope;
  final num cardiacOutput;
  final num totalPeripheralMedical;
  final num totalPeripheralCGS;
}
