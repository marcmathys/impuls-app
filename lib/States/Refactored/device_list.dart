import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceListProvider = StateNotifierProvider<DeviceList, List<BluetoothDevice>>((ref) => DeviceList([]));

class DeviceList extends StateNotifier<List<BluetoothDevice>> {
  bool _isScanning = false;

  DeviceList(List<BluetoothDevice> deviceList) : super(deviceList ?? []);

  void stopScanning() {
    FlutterBlue.instance.stopScan();
    _isScanning = false;
  }

  /// Scans the environment for bluetooth devices
  void scanForDevices() async {
    FlutterBlue flutterBlue = FlutterBlue.instance;

    if (_isScanning) {
      await flutterBlue.stopScan();
      _isScanning = false;
    }

    /**TODO: Messenger?
     * if (!await flutterBlue.isOn) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bluetooth is turned off')));
        }**/

    flutterBlue.startScan(timeout: Duration(seconds: 10));
    Timer(Duration(seconds: 10), () {
      _isScanning = false;
    });
    _isScanning = true;
    flutterBlue.scanResults.listen((results) {
      List<BluetoothDevice> devices = [];
      results.forEach((element) {
        devices.add(element.device);
      });
      state = devices;
    });
  }
}
