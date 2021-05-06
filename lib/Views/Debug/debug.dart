import 'package:flutter/material.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Views/Debug/bluetooth_device_picker.dart';
import 'package:impulsrefactor/Views/Debug/ekg_value_text_bar.dart';
import 'package:impulsrefactor/Views/Debug/bluetooth_command_bar.dart';

class Debug extends StatefulWidget {
  _DebugState createState() => _DebugState();
}

/// Hint! Streams are not closed nor paused in this view! That only happens when the view is disposed!
class _DebugState extends State<Debug> {
  GlobalKey<EKGChartState> _ekgKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    backButtonPressed();
    super.dispose();
  }

  void backButtonPressed() {
    /**BtState().resetState();
        _bluetoothService.cancelSubscriptions();
        _flutterBlue.isScanning.first.then((value) {
        if (value) {
        TODO: Das handelt doch schon der BTDevicePicker?: _flutterBlue.stopScan();
        }
        });**/
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backButtonPressed();
        return true;
      },
      child: Scaffold(
        appBar: Components().appBar(context, 'Debug menu'),
        body: Builder(builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              EKGChart(),
              EKGValueTextBar(),
              Divider(thickness: 2),
              BluetoothCommandBar(_ekgKey),
              Divider(thickness: 2),
              BluetoothDevicePicker(),
            ],
          );
        }),
      ),
    );
  }
}
