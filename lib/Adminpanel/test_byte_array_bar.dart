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
  String currentSentValueAutomatic = '';
  int currentValueManual = 0;

  /// The correct one!
  void testFittingCurveZeroHighLow() {
    int currentValue = 0;

    zeroHighLowTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      ByteData data = ByteData(3);
      data.setInt16(1, currentValue, Endian.big);

      context.read(stimulationServiceProvider.notifier).sendStimulationBytes(data.buffer.asUint8List().toList());
      setState(() {
        currentSentValueAutomatic = 'Value sent: $currentValue - array: ${data.buffer.asUint8List().toList()} (0|H|L)';
      });
      currentValue++;

      if (currentValue > 1023) {
        timer.cancel();
      }
    });
  }

  sendSingleValue() {
    ByteData data = ByteData(3);
    data.setInt16(1, currentValueManual, Endian.big);

    context.read(stimulationServiceProvider.notifier).sendStimulationBytes(data.buffer.asUint8List().toList());
    setState(() {
      currentValueManual += 1;
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(currentSentValueAutomatic, style: Themes.getDefaultTextStyle()),
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
              },
            ),
          ],
        ),
        Row(
          children: [
            Text('Manually send values. Current: $currentValueManual'),
            SizedBox(width: 10),
            ElevatedButton(
                onPressed: () => setState(() {
                      currentValueManual = 0;
                    }),
                child: Text('Reset current value')),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(80.0),
          child: SizedBox(height: 200, width: 200, child: ElevatedButton(onPressed: sendSingleValue, child: Text('Send value'))),
        ),
      ],
    );
  }
}
