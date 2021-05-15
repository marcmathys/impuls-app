import 'package:flutter/material.dart';

class FittingCurveInfoWindow extends StatelessWidget {
  final String oldFirstCoefficient;
  final String oldSecondCoefficient;
  final String oldResistance;
  final String oldDataPoints;

  FittingCurveInfoWindow(this.oldFirstCoefficient, this.oldSecondCoefficient, this.oldResistance, this.oldDataPoints);

  @override
  Widget build(BuildContext context) {
    return oldFirstCoefficient != null && oldSecondCoefficient != null && oldResistance != null && oldDataPoints != null
        ? Column(
            children: [
              Text('Current formula: (log(x) - $oldFirstCoefficient) / $oldSecondCoefficient', style: Theme.of(context).textTheme.bodyText1),
              SizedBox(height: 10),
              Text('Used data points (Resistance $oldResistance Ohm):\n$oldDataPoints', style: Theme.of(context).textTheme.bodyText1),
            ],
          )
        : Text(
            'No previous fitting curve data found!', style: Theme.of(context).textTheme.bodyText2
          );
  }
}
