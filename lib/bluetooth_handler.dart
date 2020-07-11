import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/app_constants.dart';

class BluetoothHandler {
  static final BluetoothHandler _instance = BluetoothHandler._internal();

  factory BluetoothHandler() => _instance;

  BluetoothHandler._internal();

  FlutterBlue _flutterBlue = FlutterBlue.instance;
  BTState _state = BTState();
  AppConstants _constants = AppConstants();
  BluetoothDevice _device;
  StreamSubscription _stimulation;
  StreamSubscription _ekg;
  StreamSubscription _errors;
  StreamSubscription _brs;
  StreamSubscription _bpm;

  /// Cancels all subscriptions and resets their variables.
  void cancelSubscriptions() {
    _stimulation.cancel();
    _stimulation = null; //TODO: Necessary?!

    _ekg.cancel();
    _ekg = null;

    _errors.cancel();
    _errors = null;

    _brs.cancel();
    _brs = null;

    _bpm.cancel();
    _bpm = null;
  }

  /// Scans the environment for bluetooth devices and connects to the SET-device if found
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
        if (result.device.id == DeviceIdentifier('3C:71:BF:AA:92:56') ||
            result.device.id == DeviceIdentifier('24:0A:C4:1D:48:42') ||
            result.device.id == DeviceIdentifier('3C:71:BF:60:2D:A2')) {
          // TODO: Hardcoded!
          result.device.connect().then((value) {
            _device = result.device;
            _flutterBlue.stopScan();
            getCharacteristicReferences();
          });
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

  /// Disconnects from the connected bluetooth device
  void disconnectDevice() {
    if (_device == null) {
      return;
    }
    _device.disconnect();
    _device = null;
  }

  /// Discovers all characteristics and tries to get references to all important ones. Saves them in a dictionary in the bluetooth state
  void getCharacteristicReferences() {
    if (this._device == null) {
      print('Device is not connected!');
      return;
    }
    _device.discoverServices().then((services) {
      services.forEach((service) async {
        if (service.uuid == _constants.STIMULATION_UUID) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == _constants.STIMULATION_CHARACTERISTIC_UUID) {
              _state.characteristics[_constants.STIMULATION_CHARACTERISTIC_UUID] = characteristic;
            }
          }
        }

        if (service.uuid == _constants.EKG_SERVICE_UUID) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == _constants.EKG_CHARACTERISTIC_UUID) {
              _state.characteristics[_constants.EKG_CHARACTERISTIC_UUID] = characteristic;
            }
            if (characteristic.uuid == _constants.BPM_CHARACTERISTIC_UUID) {
              _state.characteristics[_constants.BPM_CHARACTERISTIC_UUID] = characteristic;
            }
          }
        }

        if (service.uuid == _constants.ERROR_SERVICE) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == _constants.ERROR_CHARACTERISTIC_UUID) {
              _state.characteristics[_constants.ERROR_CHARACTERISTIC_UUID] = characteristic;
            }
          }
        }

        if (service.uuid == _constants.BRS_SERVICE) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == _constants.BRS_CHARACTERISTIC_UUID) {
              _state.characteristics[_constants.BRS_CHARACTERISTIC_UUID] = characteristic;
            }
          }
        }
      });
    });
  }

  /// Sends "on" as integer values to the given characteristic
  Future sendOnSignal(BluetoothCharacteristic characteristic) async {
    if (characteristic == null) {
      return;
    }
    await characteristic.write([111, 110]);
  }

  /// Sends "off" as integer values to the given characteristic
  Future sendOffSignal(BluetoothCharacteristic characteristic) async {
    if (characteristic == null) {
      return;
    }
    await characteristic.write([111, 102, 102]);
  }

  /// Sends the given integers representing bytes to the stimulation characteristic
  /// Note that the stimulation characteristic supports 3 and 7 interger values, and "quit" in integer
  /// Starts listening for values
  void sendStimulationBytes(List<int> bytes) async {
    if (!_state.characteristics.containsKey(_constants.STIMULATION_CHARACTERISTIC_UUID)) {
      print('Characteristic Stimulation not found!');
      return;
    }
    BluetoothCharacteristic stimulation = _state.characteristics[_constants.STIMULATION_CHARACTERISTIC_UUID];

    await stimulation.write(bytes);

    if (bytes == [113, 117, 105, 116]) {
      _stimulation.pause();
      return;
    }
    if (_stimulation == null) {
      _stimulation = stimulation.value.listen((event) {
        _state.stimulation = event;
      });
      await stimulation.setNotifyValue(true);
    }
    if (_stimulation.isPaused) {
      _stimulation.resume();
    }
  }

  /// Send "on" to the ekg and bpm characteristic and starts listening for values
  void getEKGAndBPMData() async {
    if (this._device == null) {
      print('Device is not connected!');
      return;
    }
    if (!_state.characteristics.containsKey(_constants.EKG_CHARACTERISTIC_UUID)) {
      print('Characteristic EKG not found!');
      return;
    }

    BluetoothCharacteristic ekg = _state.characteristics[_constants.EKG_CHARACTERISTIC_UUID];
    BluetoothCharacteristic bpm = _state.characteristics[_constants.BPM_CHARACTERISTIC_UUID];

    _state.resetEkgPoints();
    await sendOnSignal(ekg);

    if (_ekg == null) {
      _ekg = ekg.value.listen((event) {
        _state.ekgPoints.add(ByteConversion.ekgByteConversion(event, _state));
      });
      await ekg.setNotifyValue(true);
    }

    if (_bpm == null) {
      _bpm = bpm.value.listen((event) {
        if (event.length == 4) {
          _state.bpm = ByteConversion.bpmByteConversion(event);
        }
      });
      await bpm.setNotifyValue(true);
    }

    if (_ekg.isPaused) {
      _ekg.resume();
    }

    if (_bpm.isPaused) {
      _bpm.resume();
    }
  }

  /// Starts listening to the error code characteristic
  void listenForErrors() async {
    if (this._device == null) {
      print('Device is not connected!');
      return;
    }
    if (!_state.characteristics.containsKey(_constants.ERROR_CHARACTERISTIC_UUID)) {
      print('Characteristic Error Code not found!');
      return;
    }

    BluetoothCharacteristic error = _state.characteristics[_constants.ERROR_CHARACTERISTIC_UUID];

    if (_errors == null) {
      _errors = error.value.listen((event) {
        if (event.length == 1) {
          ByteData errorByteData = ByteData.sublistView(Uint8List.fromList(event.reversed.toList()));
          _state.addError(errorByteData.getUint8(0));
        }
      });
      await error.setNotifyValue(true);
    }
    if (_errors.isPaused) {
      _errors.resume();
    }
  }

  /// Sends "on" to the brs characteristic and starts listening for values
  void getBRSData() async {
    if (this._device == null) {
      print('Device is not connected!');
      return;
    }
    if (!_state.characteristics.containsKey(_constants.BRS_CHARACTERISTIC_UUID)) {
      print('Characteristic Error Code not found!');
      return;
    }

    BluetoothCharacteristic brs = _state.characteristics[_constants.BRS_CHARACTERISTIC_UUID];

    await sendOnSignal(brs);

    if (_brs == null) {
      _brs = brs.value.listen((event) {
        if (event.length == 4) {
          ByteData brsByteData = ByteData.sublistView(Uint8List.fromList(event.reversed.toList()));
          _state.brs = brsByteData.getUint32(0);
        }
      });
      await brs.setNotifyValue(true);
    }
    if (_brs.isPaused) {
      _brs.resume();
    }
  }
}
