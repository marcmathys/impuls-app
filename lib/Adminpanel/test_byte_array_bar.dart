import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/stimulation_service.dart';

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

  void testFittingCurveZeroLowHigh() {
    int currentValue = 0;

    zeroLowHighTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(1, currentValue, Endian.little);

      context.read(stimulationServiceProvider.notifier).sendStimulationBytes(data.buffer.asUint8List().toList());
      setState(() {
        currentSentValue = 'Value sent: $currentValue - array: ${data.buffer.asUint8List().toList()} (0|L|H)';
      });
      currentValue++;

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  /// The correct one!
  void testFittingCurveZeroHighLow() {
    int currentValue = 0;

    zeroHighLowTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(1, currentValue, Endian.big);

      context.read(stimulationServiceProvider.notifier).sendStimulationBytes(data.buffer.asUint8List().toList());
      setState(() {
        currentSentValue = 'Value sent: $currentValue - array: ${data.buffer.asUint8List().toList()} (0|H|L)';
      });
      currentValue++;

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  void testFittingCurveLowHighZero() {
    int currentValue = 0;

    lowHighZeroTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(0, currentValue, Endian.little);

      context.read(stimulationServiceProvider.notifier).sendStimulationBytes(data.buffer.asUint8List().toList());
      setState(() {
        currentSentValue = 'Value sent: $currentValue - array: ${data.buffer.asUint8List().toList()} (L|H|0)';
      });
      currentValue++;

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  void testFittingCurveHighLowZero() {
    int currentValue = 0;

    highLowZeroTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(0, currentValue, Endian.big);

      context.read(stimulationServiceProvider.notifier).sendStimulationBytes(data.buffer.asUint8List().toList());
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
        Text(currentSentValue, style: Theme.of(context).textTheme.bodyText1),
        Row(
          children: [
            Text('Send byte values 0 - 1023 to EKG. Format: 0|Low|High', style: Theme.of(context).textTheme.bodyText1),
            Switch(
                value: zeroLowHigh,
                onChanged: (value) {
                  if (value) {
                    testFittingCurveZeroLowHigh();

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
            Text('Send byte values 0 - 1023 to EKG. Format: 0|High|Low', style: Theme.of(context).textTheme.bodyText1),
            Switch(
                value: zeroHighLow,
                onChanged: (value) {
                  if (value) {
                    testFittingCurveZeroHighLow();

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
            Text('Send byte values 0 - 1023 to EKG. Format: Low|High|0', style: Theme.of(context).textTheme.bodyText1),
            Switch(
                value: lowHighZero,
                onChanged: (value) {
                  if (value) {
                    testFittingCurveLowHighZero();

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
            Text('Send byte values 0 - 1023 to EKG. Format: High|Low|0', style: Theme.of(context).textTheme.bodyText1),
            Switch(
                value: highLowZero,
                onChanged: (value) {
                  if (value) {
                    testFittingCurveHighLowZero();

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
