import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:provider/provider.dart';

class Debug extends StatefulWidget {
  @override
  _DebugState createState() => _DebugState();
}

/// Hint! Streams are not closed nor paused in this view! That only happens when the view is disposed!
class _DebugState extends State<Debug> {
  GlobalKey<EKGChartState> _ekgKey = GlobalKey();
  FlutterBlue _flutterBlue;
  BtService _bluetoothService;
  BTState _btState;
  TextEditingController _textController;
  bool stimSwitch = false;
  bool ekgSwitch = false;
  bool errorSwitch = true;
  bool brsSwitch = false;

  @override
  void initState() {
    super.initState();
    _flutterBlue = FlutterBlue.instance;
    _bluetoothService = BtService();
    _textController = TextEditingController();
  }

  void backButtonPressed() {
    _btState.resetState();
    _bluetoothService.cancelSubscriptions();
    _flutterBlue.isScanning.first.then((value) {
      if (value) {
        _flutterBlue.stopScan();
      }
    });
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

  Widget build(BuildContext context) {
    if (_btState == null) {
      _btState = Provider.of<BTState>(context);
    }

    return WillPopScope(
      onWillPop: () async {
        backButtonPressed();
        return true;
      },
      child: Scaffold(
        appBar: Components.appBar(context, 'Debug menu'),
        body: Builder(builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              EKGChart(key: _ekgKey),
              Text('Stimulation characteristic answer: ${_btState.stimulation.toString()}'),
              Text('Beats per minute: ${_btState.bpm.toStringAsFixed(2)}'),
              Text('Error code: ${_btState.error.toString()}'),
              Text('Baur Reflex Sensitivity: ${_btState.brs.toString()}'),
              Container(height: 10),
              Divider(thickness: 2),
              Container(height: 10),
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
                          _bluetoothService.getEKGAndBPMData(context, _ekgKey);

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
              Container(height: 10),
              Divider(thickness: 2),
              Container(height: 10),
              Text('Currently connected to: ${_btState.device?.id ?? 'none'} ${_btState.device?.name ?? ''}'),
              ExpansionTile(
                  title: Text('Expand to search for devices'),
                  initiallyExpanded: false,
                  onExpansionChanged: (isExpanded) {
                    if (isExpanded) {
                      _bluetoothService.scanForDevices(context);
                    } else {
                      _flutterBlue.stopScan();
                    }
                  },
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _btState.scannedDevices.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('ID: ${_btState.scannedDevices.elementAt(index).id} ${_btState.scannedDevices.elementAt(index).name}'),
                              onTap: () async {
                                await _bluetoothService.connectDevice(context, _btState.scannedDevices.elementAt(index));
                                _bluetoothService.listenForErrors(context);
                              },
                            );
                          }),
                    ),
                  ]),
              RaisedButton(
                onPressed: () {
                  _bluetoothService.disconnectDevice(context);
                  setState(() {});
                },
                child: Text('Disconnect device'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
