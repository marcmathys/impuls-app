import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/stimulation_service.dart';
import 'package:impulsrefactor/Style/themes.dart';

class ByteArrayTestBar extends StatefulWidget {
  @override
  _ByteArrayTestBarState createState() => _ByteArrayTestBarState();
}

class _ByteArrayTestBarState extends State<ByteArrayTestBar> {
  bool zeroHighLow = false;
  Timer zeroHighLowTimer;
  String currentSentValue = '';

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

  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(currentSentValue, style: Themes.getDefaultTextStyle()),
        Row(
          children: [
            Text('Send byte values 0 - 1023 to EKG. Format: 0|High|Low', style: Themes.getSmallTextStyle()),
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
      ],
    );
  }
}
