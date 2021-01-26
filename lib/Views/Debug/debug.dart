import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Views/Debug/bluetooth_device_picker.dart';
import 'package:impulsrefactor/Views/Debug/ekg_value_text_bar.dart';
import 'package:impulsrefactor/Views/Debug/bluetooth_command_bar.dart';
import 'package:provider/provider.dart';

class Debug extends StatefulWidget {
  _DebugState createState() => _DebugState();
}

/// Hint! Streams are not closed nor paused in this view! That only happens when the view is disposed!
class _DebugState extends State<Debug> {
  GlobalKey<EKGChartState> _ekgKey = GlobalKey();
  FlutterBlue _flutterBlue;
  BtService _bluetoothService;

  @override
  void initState() {
    super.initState();
    _flutterBlue = FlutterBlue.instance;
    _bluetoothService = BtService();
  }

  @override
  void dispose() {
    backButtonPressed();
    super.dispose();
  }

  void backButtonPressed() {
    BtState().resetState();
    _bluetoothService.cancelSubscriptions();
    _flutterBlue.isScanning.first.then((value) {
      if (value) {
        _flutterBlue.stopScan();
      }
    });
  }

  Widget build(BuildContext context) {
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
              EKGValueTextBar(),
              Divider(thickness: 2),
              BluetoothCommandBar(_ekgKey),
              Divider(thickness: 2),
              Selector<BtState, BluetoothDevice>(
                  selector: (_, state) => state.device,
                  builder: (_, device, __) {
                    return Text('Currently connected to: ${device?.id ?? 'none'} ${device?.name ?? ''}');
                  }),
              BluetoothDevicePicker(),
            ],
          );
        }),
      ),
    );
  }
}
