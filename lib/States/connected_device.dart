import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/States/error_service.dart';
import 'package:impulsrefactor/app_constants.dart';

final connectedDeviceProvider = StateNotifierProvider<ConnectedDevice, BluetoothDevice>((ref) => ConnectedDevice(null, ref));

class ConnectedDevice extends StateNotifier<BluetoothDevice> {
  ProviderReference ref;
  StreamSubscription _connectionStateListener;
  Map<Guid, BluetoothCharacteristic> characteristics = {};

  ConnectedDevice(BluetoothDevice connectedDevice, this.ref) : super(connectedDevice ?? null);

  void connectDevice(BluetoothDevice device) async {
    if (state != null) {
      await state.disconnect();
    }

    await device.connect();

    _connectionStateListener = device.state.listen((event) {
      if (event == BluetoothDeviceState.disconnected) {
        state = null; //TODO: Remove, because it interferes with reconnecting!
        Get.snackbar('', 'Device got disconnected');
      }
      if (event == BluetoothDeviceState.connected) {
        ref.read(errorServiceProvider.notifier).listenForErrors();
        Get.snackbar('', 'Device connected');
      }
    });

    state = device;
    await _getCharacteristicReferences();
  }

  /// Discovers all characteristics and tries to get references to all important ones. Saves them in a dictionary in the bluetooth state
  Future<void> _getCharacteristicReferences() async {
    if (state == null) {
      Get.snackbar('Device Error', 'Cannot get characteristics: No Device connected');
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
