import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';

class ByteArrayTestBar extends StatefulWidget {
  @override
  _ByteArrayTestBarState createState() => _ByteArrayTestBarState();
}

class _ByteArrayTestBarState extends State<ByteArrayTestBar> {
  bool zeroLowHigh = false;
  bool zeroHighLow = false;
  bool lowHighZero = false;
  bool highLowZero = false;

  Timer zeroLowHighTimer;
  Timer zeroHighLowTimer;
  Timer lowHighZeroTimer;
  Timer highLowZeroTimer;

  String currentSentValue = '';

  void testFittingCurveZeroLowHigh(BuildContext context) {
    int currentValue = 0;

    zeroLowHighTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(1, currentValue, Endian.little);

      BtService().sendStimulationBytes(context, data.buffer.asUint8List().toList());
      setState(() {
        currentSentValue = 'Value sent: $currentValue - array: ${data.buffer.asUint8List().toList()} (0|L|H)';
      });
      currentValue++;

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  void testFittingCurveZeroHighLow(BuildContext context) {
    int currentValue = 0;

    zeroHighLowTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(1, currentValue, Endian.big);

      BtService().sendStimulationBytes(context, data.buffer.asUint8List().toList());
      setState(() {
        currentSentValue = 'Value sent: $currentValue - array: ${data.buffer.asUint8List().toList()} (0|H|L)';
      });
      currentValue++;

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  void testFittingCurveLowHighZero(BuildContext context) {
    int currentValue = 0;

    lowHighZeroTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(0, currentValue, Endian.little);

      BtService().sendStimulationBytes(context, data.buffer.asUint8List().toList());
      setState(() {
        currentSentValue = 'Value sent: $currentValue - array: ${data.buffer.asUint8List().toList()} (L|H|0)';
      });
      currentValue++;

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  void testFittingCurveHighLowZero(BuildContext context) {
    int currentValue = 0;

    highLowZeroTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(0, currentValue, Endian.big);

      BtService().sendStimulationBytes(context, data.buffer.asUint8List().toList());
      setState(() {
        currentSentValue = 'Value sent: $currentValue - array: ${data.buffer.asUint8List().toList()} (H|L|0)';
      });
      currentValue++;

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(currentSentValue),
        Row(
          children: [
            Text('Send byte values 0 - 1023 to EKG. Format: 0|Low|High'),
            Switch(
                value: zeroLowHigh,
                onChanged: (value) {
                  if (value) {
                    testFittingCurveZeroLowHigh(context);

                    setState(() {
                      zeroLowHigh = !zeroLowHigh;
                    });
                  } else {
                    zeroLowHighTimer.cancel();

                    setState(() {
                      zeroLowHigh = !zeroLowHigh;
                      zeroLowHighTimer = null;
                    });
                  }
                }),
          ],
        ),
        Row(
          children: [
            Text('Send byte values 0 - 1023 to EKG. Format: 0|High|Low'),
            Switch(
                value: zeroHighLow,
                onChanged: (value) {
                  if (value) {
                    testFittingCurveZeroHighLow(context);

                    setState(() {
                      zeroHighLow = !zeroHighLow;
                    });
                  } else {
                    zeroHighLowTimer.cancel();

                    setState(() {
                      zeroHighLow = !zeroHighLow;
                      zeroHighLowTimer = null;
                    });
                  }
                }),
          ],
        ),
        Row(
          children: [
            Text('Send byte values 0 - 1023 to EKG. Format: Low|High|0'),
            Switch(
                value: lowHighZero,
                onChanged: (value) {
                  if (value) {
                    testFittingCurveLowHighZero(context);

                    setState(() {
                      lowHighZero = !lowHighZero;
                    });
                  } else {
                    lowHighZeroTimer.cancel();

                    setState(() {
                      lowHighZero = !lowHighZero;
                      lowHighZeroTimer = null;
                    });
                  }
                }),
          ],
        ),
        Row(
          children: [
            Text('Send byte values 0 - 1023 to EKG. Format: High|Low|0'),
            Switch(
                value: highLowZero,
                onChanged: (value) {
                  if (value) {
                    testFittingCurveHighLowZero(context);

                    setState(() {
                      highLowZero = !highLowZero;
                    });
                  } else {
                    highLowZeroTimer.cancel();

                    setState(() {
                      highLowZero = !highLowZero;
                      highLowZeroTimer = null;
                    });
                  }
                }),
          ],
        ),
      ],
    );
  }
}
