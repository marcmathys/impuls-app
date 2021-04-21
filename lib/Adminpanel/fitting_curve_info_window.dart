import 'dart:async';

import 'package:flutter/material.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';

class FittingCurveInfoWindow extends StatelessWidget {
  final String oldFirstCoefficient;
  final String oldSecondCoefficient;
  final String oldResistance;
  final String oldDataPoints;

  FittingCurveInfoWindow(this.oldFirstCoefficient, this.oldSecondCoefficient, this.oldResistance, this.oldDataPoints);

  void testFittingCurve(BuildContext context) {
    int currentValue = 0;

    Timer.periodic(Duration(milliseconds: 200), (timer) async {
      List<int> byteList = ByteConversion.convertIntToByteList(currentValue);
      BtService().sendStimulationBytes(context, byteList);

      currentValue++;
      print(currentValue);
      print(byteList);
      print('---------------');

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return oldFirstCoefficient != null && oldSecondCoefficient != null && oldResistance != null && oldDataPoints != null
        ? Column(
            children: [
              ElevatedButton(onPressed: () => testFittingCurve(context), child: Text('Send test values ranging from 0-1023 to EKG')),
              Text('Current formula: (log(x) - $oldFirstCoefficient) / $oldSecondCoefficient'),
              SizedBox(height: 10),
              Text('Used data points (Resistance $oldResistance Ohm):\n$oldDataPoints'),
            ],
          )
        : Text(
            'No previous fitting curve data found!',
            style: TextStyle(color: Colors.red),
          );
  }
}
