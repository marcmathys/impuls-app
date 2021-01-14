import 'package:flutter/material.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:provider/provider.dart';

class SwitchBar extends StatefulWidget {
  final GlobalKey<EKGChartState> _ekgKey;

  SwitchBar(this._ekgKey);

  @override
  _SwitchBarState createState() => _SwitchBarState();
}

class _SwitchBarState extends State<SwitchBar> {
  bool stimSwitch = false;
  bool ekgSwitch = false;
  bool brsSwitch = false;
  TextEditingController _textController;
  BtService _bluetoothService;
  BTState _btState;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _bluetoothService = BtService();
  }

  void sendBytesOnPressed(bool value) {
    if (value) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Input integer data separated by comma:'),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Send'),
                onPressed: () {
                  List<int> hexList = ByteConversion.stringToHex(_textController.value.text);
                  if (hexList.length == 0) {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('The given numbers are in the wrong format! Example format: 111,110,109')));
                  } else {
                    _bluetoothService.sendStimulationBytes(context, hexList);

                    ///TODO: setState assumes communication success!
                    setState(() {
                      stimSwitch = !stimSwitch;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));
    } else {
      _bluetoothService.sendStimulationBytes(context, [113, 117, 105, 116]); // Send stop
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_btState == null) {
      _btState = Provider.of<BTState>(context);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Send bytes to stimulation characteristic'),
            Switch(value: stimSwitch, onChanged: sendBytesOnPressed),
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
                    _bluetoothService.getEKGAndBPMData(context, widget._ekgKey);

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
