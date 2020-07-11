import 'dart:async';

import 'package:flutter/material.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/Views/Components/chart_component.dart';
import 'package:impulsrefactor/Views/Components/components.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:impulsrefactor/bluetooth_handler.dart';
import 'package:provider/provider.dart';

class Debug extends StatefulWidget {
  @override
  _DebugState createState() => _DebugState();
}

/// TODO: Hint! Streams are not closed nor paused in this view! That only happens when the view is disposed!
class _DebugState extends State<Debug> {
  BluetoothHandler _handler;
  BTState _state;
  AppConstants _constants;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _handler = BluetoothHandler();
    _state = BTState();
    _constants = AppConstants();
    _textController = TextEditingController();
  }


  @override
  void dispose() {
    super.dispose();
    _handler.cancelSubscriptions();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components.appBar('Debug menu'),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            Chart(),
            Text('Stimulation characteristic answer: ${Provider.of<BTState>(context).stimulation.toString()}'),
            Text('Beats per minute: ${Provider.of<BTState>(context).bpm.toStringAsFixed(2)}'),
            Text('Error code: ${Provider.of<BTState>(context).error.toString()}'),
            Text('Baur Reflex Sensitivity: ${Provider.of<BTState>(context).brs.toString()}'),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    _handler.scanForDevices().then((code) => Components.loginErrorSnackBar(context, code));
                  },
                  child: Text('Connect device'),
                ),
                RaisedButton(
                  onPressed: () {
                    _handler.disconnectDevice();
                  },
                  child: Text('Disconnect device'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RaisedButton(
                    onPressed: () async {
                      await showDialog(
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
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text('The given numbers are in the wrong format! Example format: 111,110,109')));
                                  } else {
                                    _handler.sendStimulationBytes(hexList);
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
                    },
                    child: Text('Send bytes to stimulation characteristic'),
                  ),
                ),
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.sendStimulationBytes([113, 117, 105, 116]), // Stands for quit
                    child: Text('Stop therapy (sends quit)'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.getEKGAndBPMData(),
                    child: Text('Get EKG and BPM data'),
                  ),
                ),
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.sendOffSignal(_state.characteristics[_constants.EKG_CHARACTERISTIC_UUID]),
                    child: Text('Stop EKG service'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.listenForErrors(),
                    child: Text('Listen for errors'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.getBRSData(),
                    child: Text('Get BRS Data'),
                  ),
                ),
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.sendOffSignal(_state.characteristics[_constants.BRS_CHARACTERISTIC_UUID]),
                    child: Text('Stop BRS Data'),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
