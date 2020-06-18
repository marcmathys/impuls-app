import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';

class BluetoothHandler {
  static final BluetoothHandler _instance = BluetoothHandler._internal();
  factory BluetoothHandler() => _instance;

  BluetoothHandler._internal();

  Guid EKG_SERVICE_UUID = Guid('00b3b02e-928b-11e9-bc42-526af7764f64');
  Guid EKG_CHARACTERISTIC_UUID = Guid('00b3b2ae-928b-11e9-bc42-526af7764f64');
  Guid IBI_CHARACTERISTIC_UUID = Guid('df60bd72-ca66-11e9-a32f-2a2ae2dbcce4');

  FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice _device;
  final List<MedicalData> ekgPoints = [];
  final ibiPoints = [];
  BluetoothCharacteristic ekgSubscription;

  /// Scans the environment for bluetooth devices and connects to the SET-device if found.
  /// Return codes:
  /// 0 - Okay.
  /// 1 - Bluetooth off
  /// 2 - Already connected
  /// 3 - Device not found
  Future<int> scanForDevices() async {
    if (!await _flutterBlue.isOn) {
      print('Please turn on bluetooth!');
      return 1;
    }

    if (!(this._device == null)) {
      print('Device already connected!');
      return 2;
    }

    _flutterBlue.startScan(timeout: Duration(seconds: 4));
    // ignore: missing_return
    _flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.id == DeviceIdentifier('3C:71:BF:AA:92:56')) { // TODO: Hardcoded!
          result.device.connect();
          _device = result.device;
          print('Connected!');
          _flutterBlue.stopScan();
          return 0;
        }
      }
    });
    return 3;
  }

  Future sendOnSignal(BluetoothCharacteristic characteristic) async {
    if(characteristic == null) {
      return;
    }
    await characteristic.write([111, 110]);
  }

  Future sendOffSignal(BluetoothCharacteristic characteristic) async {
    if(characteristic == null) {
      return;
    }
    await characteristic.write([111, 102, 102]);
  }

  void getEKGData() async {
    if (this._device == null) {
      print('Device is not connected!');
      return;
    }

    _device.discoverServices().then((services) {
      services.forEach((service) async {
        if (service.uuid == EKG_SERVICE_UUID) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == EKG_CHARACTERISTIC_UUID) {
              ekgSubscription = characteristic;
              await sendOnSignal(characteristic);
              characteristic.value.listen((event) {
                byteConversion(event);
              });
              await characteristic.setNotifyValue(true);
            }
          }
        }
      });
    });
  }

  void byteConversion(List<int> bluetoothData) {
    if (bluetoothData.length == 2) {
      if (ekgPoints.length >= 300) {
        ekgPoints.removeAt(0);
      }
      ByteData ekgByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
      int _ekgPoint = ekgByteData.getInt16(0, Endian.big);
      ekgPoints.add(MedicalData(DateTime.now(), _ekgPoint));
    } else if (bluetoothData.length == 4) {
      ByteData ibiByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
      double _ibiPoint = ibiByteData.getFloat32(0, Endian.big);
      ibiPoints.add(_ibiPoint);
    }
  }
}
