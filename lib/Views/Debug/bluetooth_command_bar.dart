import 'package:flutter/material.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:provider/provider.dart';

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
  BtService _bluetoothService;
  BtState _btState;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _bluetoothService = BtService();
  }

  void sendBytesOnPressed() {
    //_bluetoothService.sendStimulationBytes(context, [113, 117, 105, 116]); // Send stop
    try {
      List<int> octList = ByteConversion.stringToOct(_textController.value.text);
      _bluetoothService.sendStimulationBytes(context, octList);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The given numbers are in the wrong format! Example format: 111,110,109')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_btState == null) {
      _btState = Provider.of<BtState>(context);
    }

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
              child: Text('Send Bytes'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start EKG and BPM data stream'),
            Switch(
                value: ekgSwitch,
                onChanged: (value) {
                  if (value) {
                    _bluetoothService.getEKGAndBPMData(context);

                    ///TODO: setState assumes communication success!
                    setState(() {
                      ekgSwitch = !ekgSwitch;
                    });
                  } else {
                    _bluetoothService.sendOffSignal(_btState.characteristics[AppConstants.EKG_CHARACTERISTIC_UUID]);

                    ///TODO: setState assumes communication success!
                    setState(() {
                      ekgSwitch = !ekgSwitch;
                    });
                  }
                }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Get BRS data'),
            Switch(
              value: brsSwitch,
              onChanged: (value) {
                if (value) {
                  _bluetoothService.getBRSData(context);

                  ///TODO: setState assumes communication success!
                  setState(() {
                    brsSwitch = !brsSwitch;
                  });
                } else {
                  _bluetoothService.sendOffSignal(_btState.characteristics[AppConstants.BRS_CHARACTERISTIC_UUID]);

                  ///TODO: setState assumes communication success!
                  setState(() {
                    brsSwitch = !brsSwitch;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
