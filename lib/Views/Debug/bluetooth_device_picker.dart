import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:provider/provider.dart';

class BluetoothDevicePicker extends StatefulWidget {
  @override
  _BluetoothDevicePickerState createState() => _BluetoothDevicePickerState();
}

class _BluetoothDevicePickerState extends State<BluetoothDevicePicker> {
  BtService _bluetoothService;
  BTState _btState;
  FlutterBlue _flutterBlue;

  @override
  void initState() {
    super.initState();
    _bluetoothService = BtService();
    _flutterBlue = FlutterBlue.instance;
  }

  @override
  Widget build(BuildContext context) {
    if (_btState == null) {
      _btState = Provider.of<BTState>(context);
    }

    return Column(
      children: [
        Visibility(
          visible: _btState.device != null,
          child: RaisedButton(
            onPressed: () {
              _bluetoothService.disconnectDevice(context);
              _bluetoothService.cancelSubscriptions();
              _btState.resetState();
            },
            child: Text('Disconnect device'),
          ),
        ),
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
                          bool success = await _bluetoothService.connectDevice(context, _btState.scannedDevices.elementAt(index));
                          if (success) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Device successfully connected')));
                            _bluetoothService.listenForErrors(context);
                          }
                        },
                      );
                    }),
              ),
            ]),
      ],
    );
  }
}
