import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/States/ekg_state.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:provider/provider.dart';

class BtService {
  static final BtService _instance = BtService._internal();

  factory BtService() => _instance;

  BtService._internal();

  StreamSubscription _stimulation;
  StreamSubscription _ekg;
  StreamSubscription _errors;
  StreamSubscription _brs;
  StreamSubscription _bpm;
  StreamSubscription _stateListener;

  /// Cancels all subscriptions and resets their variables.
  void cancelSubscriptions() {
    if (_stimulation != null) {
      _stimulation.cancel();
      _stimulation = null;
    }
    if (_ekg != null) {
      _ekg.cancel();
      _ekg = null;
    }
    if (_errors != null) {
      _errors.cancel();
      _errors = null;
    }
    if (_brs != null) {
      _brs.cancel();
      _brs = null;
    }
    if (_bpm != null) {
      _bpm.cancel();
      _brs = null;
    }
    if (_stateListener != null) {
      _stateListener.cancel();
      _stateListener = null;
    }
  }

  /// Scans the environment for bluetooth devices and connects to the SET-device if found
  void scanForDevices(BuildContext context) async {
    BtState bluetoothState = Provider.of<BtState>(context, listen: false);
    FlutterBlue flutterBlue = FlutterBlue.instance;

    if (!await flutterBlue.isOn) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bluetooth is turned off')));
    }

    bluetoothState.resetScannedDevicesList();
    flutterBlue.startScan(timeout: Duration(seconds: 10));
    flutterBlue.scanResults.listen((results) {
      List<BluetoothDevice> devices = [];
      results.forEach((element) {
        devices.add(element.device);
      });
      bluetoothState.setDeviceList(devices);
    });
  }

  Future<bool> connectDevice(BuildContext context, BluetoothDevice device) async {
    BtState bluetoothState = Provider.of<BtState>(context, listen: false);

    if (bluetoothState.device != null) {
      await bluetoothState.device.disconnect();
    }

    await device.connect();

    _stateListener = device.state.listen((event) {
      if (event == BluetoothDeviceState.disconnected) {
        print('State event: $event');
        bluetoothState.device = null;
        cancelSubscriptions();
        //TODO: Set a Variable in a state that, at another point in the code, triggers the message! (Via Consumer!) (Do the same for all instances of ScaffoldMessenger!)
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Device got disconnected')));
      }
    });

    bluetoothState.device = device;
    await getCharacteristicReferences(context);

    if (bluetoothState.device != null) {
      return true;
    } else {
      return false;
    }
  }

  /// Disconnects the connected bluetooth device
  void disconnectDevice(BuildContext context) {
    BtState bluetoothState = Provider.of<BtState>(context, listen: false);

    if (bluetoothState.device == null) {
      return;
    }
    bluetoothState.device.disconnect();
  }

  /// Discovers all characteristics and tries to get references to all important ones. Saves them in a dictionary in the bluetooth state
  Future<void> getCharacteristicReferences(BuildContext context) async {
    BtState bluetoothState = Provider.of<BtState>(context, listen: false);

    if (bluetoothState.device == null) {
      print('Device is not connected!');
      return;
    }

    List<BluetoothService> services = await bluetoothState.device.discoverServices();
    services.forEach((service) {
      if (service.uuid == AppConstants.STIMULATION_UUID) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in characteristics) {
          if (characteristic.uuid == AppConstants.STIMULATION_CHARACTERISTIC_UUID) {
            bluetoothState.characteristics[AppConstants.STIMULATION_CHARACTERISTIC_UUID] = characteristic;
          }
        }
      }

      if (service.uuid == AppConstants.EKG_SERVICE_UUID) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in characteristics) {
          if (characteristic.uuid == AppConstants.EKG_CHARACTERISTIC_UUID) {
            bluetoothState.characteristics[AppConstants.EKG_CHARACTERISTIC_UUID] = characteristic;
          }
          if (characteristic.uuid == AppConstants.BPM_CHARACTERISTIC_UUID) {
            bluetoothState.characteristics[AppConstants.BPM_CHARACTERISTIC_UUID] = characteristic;
          }
        }
      }

      if (service.uuid == AppConstants.ERROR_SERVICE) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in characteristics) {
          if (characteristic.uuid == AppConstants.ERROR_CHARACTERISTIC_UUID) {
            bluetoothState.characteristics[AppConstants.ERROR_CHARACTERISTIC_UUID] = characteristic;
          }
        }
      }

      if (service.uuid == AppConstants.BRS_SERVICE) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in characteristics) {
          if (characteristic.uuid == AppConstants.BRS_CHARACTERISTIC_UUID) {
            bluetoothState.characteristics[AppConstants.BRS_CHARACTERISTIC_UUID] = characteristic;
          }
        }
      }
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
  /// Note that the stimulation characteristic supports 3 and 7 integer values, and "quit" in integer
  /// Starts listening for values
  void sendStimulationBytes(BuildContext context, List<int> bytes) async {
    BtState bluetoothState = Provider.of<BtState>(context, listen: false);

    if (bluetoothState.device == null) {
      print('Device is not connected!');
      return;
    }

    if (!bluetoothState.characteristics.containsKey(AppConstants.STIMULATION_CHARACTERISTIC_UUID)) {
      print('Characteristic Stimulation not found!');
      return;
    }

    BluetoothCharacteristic stimulation = bluetoothState.characteristics[AppConstants.STIMULATION_CHARACTERISTIC_UUID];
    await stimulation.write(bytes);

    if (bytes == [113, 117, 105, 116]) {
      _stimulation.pause();
      return;
    }
    if (_stimulation == null) {
      _stimulation = stimulation.value.listen((event) {
        bluetoothState.stimulation = event;
      });
      await stimulation.setNotifyValue(true);
    }
    if (_stimulation.isPaused) {
      _stimulation.resume();
    }
  }

  /// Send "on" to the ekg and bpm characteristic and starts listening for values
  void getEKGAndBPMData(BuildContext context) async {
    BtState bluetoothState = Provider.of<BtState>(context, listen: false);

    if (bluetoothState.device == null) {
      print('Device is not connected!');
      return;
    }

    if (!bluetoothState.characteristics.containsKey(AppConstants.EKG_CHARACTERISTIC_UUID)) {
      print('Characteristic EKG not found!');
      return;
    }

    BluetoothCharacteristic ekgCharacteristic = bluetoothState.characteristics[AppConstants.EKG_CHARACTERISTIC_UUID];
    BluetoothCharacteristic bpmCharacteristic = bluetoothState.characteristics[AppConstants.BPM_CHARACTERISTIC_UUID];

    Provider.of<EkgState>(context, listen: false).resetEkgPoints();
    await sendOnSignal(ekgCharacteristic);

    if (_ekg == null) {
      _ekg = ekgCharacteristic.value.listen((event) {
        Provider.of<EkgState>(context, listen: false).addEkgPoint(event);
      });
      await ekgCharacteristic.setNotifyValue(true);
    }

    if (_bpm == null) {
      _bpm = bpmCharacteristic.value.listen((event) {
        if (event.length == 4) {
          bluetoothState.bpm = ByteConversion.bpmByteConversion(event);
        }
      });
      await bpmCharacteristic.setNotifyValue(true);
    }

    if (_ekg.isPaused) {
      _ekg.resume();
    }

    if (_bpm.isPaused) {
      _bpm.resume();
    }
  }

  /// Starts listening to the error code characteristic
  void listenForErrors(BuildContext context) async {
    BtState bluetoothState = Provider.of<BtState>(context, listen: false);

    if (bluetoothState.device == null) {
      print('Device is not connected!');
      return;
    }
    if (!bluetoothState.characteristics.containsKey(AppConstants.ERROR_CHARACTERISTIC_UUID)) {
      print('Characteristic Error Code not found!');
      return;
    }

    BluetoothCharacteristic error = bluetoothState.characteristics[AppConstants.ERROR_CHARACTERISTIC_UUID];

    if (_errors == null) {
      _errors = error.value.listen((event) {
        if (event.length == 1) {
          ByteData errorByteData = ByteData.sublistView(Uint8List.fromList(event.reversed.toList()));
          bluetoothState.addError(errorByteData.getUint8(0));
        }
      });
      await error.setNotifyValue(true);
    }
    if (_errors.isPaused) {
      _errors.resume();
    }
  }

  /// Sends "on" to the brs characteristic and starts listening for values
  void getBRSData(BuildContext context) async {
    BtState bluetoothState = Provider.of<BtState>(context, listen: false);

    if (bluetoothState.device == null) {
      print('Device is not connected!');
      return;
    }
    if (!bluetoothState.characteristics.containsKey(AppConstants.BRS_CHARACTERISTIC_UUID)) {
      print('Characteristic Error Code not found!');
      return;
    }

    BluetoothCharacteristic brs = bluetoothState.characteristics[AppConstants.BRS_CHARACTERISTIC_UUID];

    await sendOnSignal(brs);

    if (_brs == null) {
      _brs = brs.value.listen((event) {
        if (event.length == 4) {
          ByteData brsByteData = ByteData.sublistView(Uint8List.fromList(event.reversed.toList()));
          bluetoothState.brs = brsByteData.getUint32(0);
        }
      });
      await brs.setNotifyValue(true);
    }
    if (_brs.isPaused) {
      _brs.resume();
    }
  }
}
