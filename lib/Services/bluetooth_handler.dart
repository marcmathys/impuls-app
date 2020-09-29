import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/States/message_state.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/app_constants.dart';

class BluetoothHandler {
  static final BluetoothHandler _instance = BluetoothHandler._internal();

  factory BluetoothHandler() => _instance;

  BluetoothHandler._internal();

  FlutterBlue _flutterBlue = FlutterBlue.instance;
  BTState _state = BTState();
  BluetoothDevice _device;
  StreamSubscription _stimulation;
  StreamSubscription _ekg;
  StreamSubscription _errors;
  StreamSubscription _brs;
  StreamSubscription _bpm;

  /// Cancels all subscriptions and resets their variables.
  void cancelSubscriptions() {
    if (_stimulation != null) {
      _stimulation.cancel();
    }
    if (_ekg != null) {
      _ekg.cancel();
    }
    if (_errors != null) {
      _errors.cancel();
    }
    if (_brs != null) {
      _brs.cancel();
    }
    if (_bpm != null) {
      _bpm.cancel();
    }
  }

  /// Scans the environment for bluetooth devices and connects to the SET-device if found
  /// Return codes:
  /// 0 - Okay
  /// 1 - Bluetooth off
  /// 2 - Already connected
  /// 3 - Device not found
  void scanForDevices(MessageState state) async {
    if (!await _flutterBlue.isOn) {
      state.message = ToastMessages.BluetoothOff;
    }

    if (!(this._device == null)) {
      state.message = ToastMessages.deviceAlreadyConnected;
    }

    _flutterBlue.startScan(timeout: Duration(seconds: 4)).then((_) {
      if (_device == null) {
        state.message = ToastMessages.deviceAlreadyConnected;
      }
    });
    _flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.id == DeviceIdentifier('3C:71:BF:60:2D:CE') ||
            result.device.id == DeviceIdentifier('3C:71:BF:AA:92:56') ||
            result.device.id == DeviceIdentifier('24:0A:C4:1D:48:42') ||
            result.device.id == DeviceIdentifier('3C:71:BF:60:2D:A2')) {
          // TODO: Hardcoded!
          result.device.connect().then((value) {
            _device = result.device;
            _flutterBlue.stopScan();
            getCharacteristicReferences();
            state.message = ToastMessages.deviceSuccessfullyConnected;
          });
        }
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
        if (service.uuid == AppConstants.STIMULATION_UUID) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == AppConstants.STIMULATION_CHARACTERISTIC_UUID) {
              _state.characteristics[AppConstants.STIMULATION_CHARACTERISTIC_UUID] = characteristic;
            }
          }
        }

        if (service.uuid == AppConstants.EKG_SERVICE_UUID) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == AppConstants.EKG_CHARACTERISTIC_UUID) {
              _state.characteristics[AppConstants.EKG_CHARACTERISTIC_UUID] = characteristic;
            }
            if (characteristic.uuid == AppConstants.BPM_CHARACTERISTIC_UUID) {
              _state.characteristics[AppConstants.BPM_CHARACTERISTIC_UUID] = characteristic;
            }
          }
        }

        if (service.uuid == AppConstants.ERROR_SERVICE) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == AppConstants.ERROR_CHARACTERISTIC_UUID) {
              _state.characteristics[AppConstants.ERROR_CHARACTERISTIC_UUID] = characteristic;
            }
          }
        }

        if (service.uuid == AppConstants.BRS_SERVICE) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic characteristic in characteristics) {
            if (characteristic.uuid == AppConstants.BRS_CHARACTERISTIC_UUID) {
              _state.characteristics[AppConstants.BRS_CHARACTERISTIC_UUID] = characteristic;
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
    if (!_state.characteristics.containsKey(AppConstants.STIMULATION_CHARACTERISTIC_UUID)) {
      print('Characteristic Stimulation not found!');
      return;
    }
    BluetoothCharacteristic stimulation = _state.characteristics[AppConstants.STIMULATION_CHARACTERISTIC_UUID];

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
  void getEKGAndBPMData(GlobalKey<EKGChartState> ekgChartKey) async {
    if (this._device == null) {
      print('Device is not connected!');
      return;
    }
    if (!_state.characteristics.containsKey(AppConstants.EKG_CHARACTERISTIC_UUID)) {
      print('Characteristic EKG not found!');
      return;
    }

    BluetoothCharacteristic ekg = _state.characteristics[AppConstants.EKG_CHARACTERISTIC_UUID];
    BluetoothCharacteristic bpm = _state.characteristics[AppConstants.BPM_CHARACTERISTIC_UUID];

    ekgChartKey.currentState.resetEkgPoints();
    await sendOnSignal(ekg);

    if (_ekg == null) {
      _ekg = ekg.value.listen((event) {
        ekgChartKey.currentState.updateList(event);
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
    if (!_state.characteristics.containsKey(AppConstants.ERROR_CHARACTERISTIC_UUID)) {
      print('Characteristic Error Code not found!');
      return;
    }

    BluetoothCharacteristic error = _state.characteristics[AppConstants.ERROR_CHARACTERISTIC_UUID];

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
    if (!_state.characteristics.containsKey(AppConstants.BRS_CHARACTERISTIC_UUID)) {
      print('Characteristic Error Code not found!');
      return;
    }

    BluetoothCharacteristic brs = _state.characteristics[AppConstants.BRS_CHARACTERISTIC_UUID];

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
