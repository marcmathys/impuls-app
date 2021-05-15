import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/app_constants.dart';

final connectedDeviceProvider = StateNotifierProvider<ConnectedDevice, BluetoothDevice>((ref) => ConnectedDevice(null));

class ConnectedDevice extends StateNotifier<BluetoothDevice> {
  ConnectedDevice(BluetoothDevice connectedDevice) : super(connectedDevice ?? null);
  StreamSubscription _connectionStateListener;
  Map<Guid, BluetoothCharacteristic> characteristics = {};

  /// Disconnects the connected bluetooth device
  void disconnectDevice() {
    if (state == null) {
      return;
    }
    state.disconnect();
  }

  Future<bool> connectDevice(BluetoothDevice device) async {
    if (state != null) {
      await state.disconnect();
    }

    await device.connect();

    _connectionStateListener = device.state.listen((event) {
      if (event == BluetoothDeviceState.disconnected) {
        print('State event: $event');
        state = null;
        _connectionStateListener.cancel();
        //TODO: Set a Variable in a state that, at another point in the code, triggers the message! (Via Consumer!) (Do the same for all instances of ScaffoldMessenger!)
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Device got disconnected', style: Theme.of(context).textTheme.bodyText1)));
      }
    });

    state = device;
    await _getCharacteristicReferences();

    if (state != null) {
      return true;
    } else {
      return false;
    }
  }

  /// Discovers all characteristics and tries to get references to all important ones. Saves them in a dictionary in the bluetooth state
  Future<void> _getCharacteristicReferences() async {
    if (state == null) {
      print('Device is not connected!');
      return;
    }

    List<BluetoothService> services = await state.discoverServices();

    services.forEach((service) {
      if (service.uuid == AppConstants.STIMULATION_UUID) {
        var serviceCharacteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in serviceCharacteristics) {
          if (characteristic.uuid == AppConstants.STIMULATION_CHARACTERISTIC_UUID) {
            characteristics[AppConstants.STIMULATION_CHARACTERISTIC_UUID] = characteristic;
          }
        }
      }

      if (service.uuid == AppConstants.EKG_SERVICE_UUID) {
        var serviceCharacteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in serviceCharacteristics) {
          if (characteristic.uuid == AppConstants.EKG_CHARACTERISTIC_UUID) {
            characteristics[AppConstants.EKG_CHARACTERISTIC_UUID] = characteristic;
          }
          if (characteristic.uuid == AppConstants.BPM_CHARACTERISTIC_UUID) {
            characteristics[AppConstants.BPM_CHARACTERISTIC_UUID] = characteristic;
          }
        }
      }

      if (service.uuid == AppConstants.ERROR_SERVICE) {
        var serviceCharacteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in serviceCharacteristics) {
          if (characteristic.uuid == AppConstants.ERROR_CHARACTERISTIC_UUID) {
            characteristics[AppConstants.ERROR_CHARACTERISTIC_UUID] = characteristic;
          }
        }
      }

      if (service.uuid == AppConstants.BRS_SERVICE) {
        var serviceCharacteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in serviceCharacteristics) {
          if (characteristic.uuid == AppConstants.BRS_CHARACTERISTIC_UUID) {
            characteristics[AppConstants.BRS_CHARACTERISTIC_UUID] = characteristic;
          }
        }
      }
    });
  }
}
