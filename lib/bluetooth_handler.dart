import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Entities/ibi_point.dart';
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
  final List<MedicalData> ekgPoints = [MedicalData(DateTime.now(), 0, 0)];
  final List<IbiPoint> ibiPoints = [IbiPoint(0, 0)];
  BluetoothCharacteristic ekgSubscription;
  StreamSubscription ibiSubscription;

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
        if (result.device.id == DeviceIdentifier('3C:71:BF:AA:92:56') || result.device.id == DeviceIdentifier('24:0A:C4:1D:48:42')) {
          // TODO: Hardcoded!
          result.device.connect();
          _device = result.device;
          _flutterBlue.stopScan();
          return 0;
        }
      }
    });
    // ignore: missing_return
    _flutterBlue.isScanning.listen((event) {
      if (!event && _device == null) {
        return 3;
      }
    });
  }

  void disconnectDevice() {
    if (_device == null) {
      return;
    }
    _device.disconnect();
    _device = null;
  }

  Future sendOnSignal(BluetoothCharacteristic characteristic) async {
    if (characteristic == null) {
      return;
    }
    await characteristic.write([111, 110]);
  }

  Future sendOffSignal(BluetoothCharacteristic characteristic) async {
    if (characteristic == null) {
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
                ekgPoints.add(ekgByteConversion(event));
              });
              await characteristic.setNotifyValue(true);
            }
          }
        }
      });
    });
  }

  void getIBIData() async {
    if (this._device == null) {
      print('Device is not connected!');
      return;
    }

    _device.discoverServices().then((services) {
      services.forEach((service) async {
        if (service.uuid == EKG_SERVICE_UUID) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == IBI_CHARACTERISTIC_UUID) {
              ibiSubscription = characteristic.value.listen((event) {
                if (event.length == 4) {
                  ibiPoints.add(ibiByteConversion(event));
                }
              });
              await characteristic.setNotifyValue(true);
            }
          }
        }
      });
    });
  }

  MedicalData ekgByteConversion(List<int> bluetoothData) {
    if (ekgPoints.length >= 300) {
      ekgPoints.removeAt(0);
    }
    ByteData ekgByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    int _ekgPoint = ekgByteData.getInt16(0, Endian.big);
    return MedicalData(DateTime.now(), _ekgPoint, ekgPoints.last.xAxis + 1);
  }

  IbiPoint ibiByteConversion(List<int> bluetoothData) {
    ByteData ibiByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    double _ibiPoint = ibiByteData.getFloat32(0, Endian.big);
    return IbiPoint(_ibiPoint, ibiPoints.last.xAxis + 1);
  }
}
