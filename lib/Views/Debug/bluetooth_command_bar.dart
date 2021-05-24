import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/States/bpm_service.dart';
import 'package:impulsrefactor/States/brs_service.dart';
import 'package:impulsrefactor/States/ekg_service.dart';
import 'package:impulsrefactor/States/stimulation_service.dart';
import 'package:impulsrefactor/Style/themes.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothCommandBar extends StatefulWidget {
  final GlobalKey<EKGChartState> _ekgKey;

  BluetoothCommandBar(this._ekgKey);

  @override
  _BluetoothCommandBarState createState() => _BluetoothCommandBarState();
}

class _BluetoothCommandBarState extends State<BluetoothCommandBar> {
  bool ekgSwitch = false;
  bool brsSwitch = false;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  void sendBytesOnPressed() {
    try {
      List<int> octList = ByteConversion.stringToOct(_textController.value.text);
      context.read(stimulationServiceProvider.notifier).sendStimulationBytes(octList);
    } catch (_) {
      Get.snackbar('Format error', 'The given numbers are in the wrong format! Example format: 111,110,109');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Enter Bytes (example: 110,110,109)', border: InputBorder.none),
            )),
            ElevatedButton(
              onPressed: () {
                sendBytesOnPressed();
              },
              child: Text('Send Bytes', style: Themes.getButtonTextStyle()),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start EKG and BPM data stream', style: Themes.getDefaultTextStyle()),
            Switch(
                value: ekgSwitch,
                onChanged: (value) {
                  if (value) {
                    context.read(ekgServiceProvider.notifier).startDataStreams();
                    context.read(bpmServiceProvider.notifier).resumeListenToBpm();

                    if (context.read(ekgServiceProvider.notifier).isStreamRunning()) {
                      setState(() {
                        ekgSwitch = !ekgSwitch;
                      });
                    }
                  } else {
                    context.read(ekgServiceProvider.notifier).pauseListenToEkg();
                    context.read(bpmServiceProvider.notifier).pauseListenToBpm();

                    if (context.read(ekgServiceProvider.notifier).isStreamRunning()) {
                      setState(() {
                        ekgSwitch = !ekgSwitch;
                      });
                    }
                  }
                }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Get BRS data', style: Themes.getDefaultTextStyle()),
            Switch(
              value: brsSwitch,
              onChanged: (value) {
                if (value) {
                  context.read(brsServiceProvider.notifier).getBRSData();

                  if (context.read(brsServiceProvider.notifier).isStreamRunning()) {
                    setState(() {
                      brsSwitch = !brsSwitch;
                    });
                  }
                } else {
                  context.read(brsServiceProvider.notifier).sendOffSignal();

                  if (!context.read(brsServiceProvider.notifier).isStreamRunning()) {
                    setState(() {
                      brsSwitch = !brsSwitch;
                    });
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
