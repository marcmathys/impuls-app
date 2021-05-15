import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/connected_device.dart';
import 'package:impulsrefactor/app_constants.dart';

final brsServiceProvider = StateNotifierProvider<BrsServiceProvider, int>((ref) => BrsServiceProvider(0, ref.read));

class BrsServiceProvider extends StateNotifier<int> {
  final Reader read;
  StreamSubscription _brsStream;

  BrsServiceProvider(int brs, this.read) : super(0);

  /// Sends "on" to the brs characteristic and starts listening for values
  void getBRSData() async {
    if (read(connectedDeviceProvider) == null) {
      print('Device is not connected!');
      return;
    }
    if (!read(connectedDeviceProvider.notifier).characteristics.containsKey(AppConstants.BRS_CHARACTERISTIC_UUID)) {
      print('Characteristic Error Code not found!');
      return;
    }

    BluetoothCharacteristic brsCharacteristic = read(connectedDeviceProvider.notifier).characteristics[AppConstants.BRS_CHARACTERISTIC_UUID];

    await sendOnSignal();

    if (_brsStream == null) {
      _brsStream = brsCharacteristic.value.listen((event) {
        if (event.length == 4) {
          ByteData brsByteData = ByteData.sublistView(Uint8List.fromList(event.reversed.toList()));
          state = brsByteData.getUint32(0);
        }
      });
      await brsCharacteristic.setNotifyValue(true);
    }
    if (_brsStream.isPaused) {
      _brsStream.resume();
    }
  }

  /// Sends "on" as integer values to the ekg service
  Future sendOnSignal() async {
    BluetoothCharacteristic brsCharacteristic = read(connectedDeviceProvider.notifier).characteristics[AppConstants.BRS_CHARACTERISTIC_UUID];

    if (brsCharacteristic == null) {
      return;
    }
    await brsCharacteristic.write([111, 110]);
  }

  /// Sends "off" as integer values to the ekg service
  Future sendOffSignal() async {
    BluetoothCharacteristic brsCharacteristic = read(connectedDeviceProvider.notifier).characteristics[AppConstants.BRS_CHARACTERISTIC_UUID];

    if (brsCharacteristic == null) {
      return;
    }
    await brsCharacteristic.write([111, 102, 102]);
  }

  void startListenToBrs() {
    if (_brsStream != null && _brsStream.isPaused) {
      _brsStream.resume();
    }
  }

  void stopListenToBrs() {
    if (_brsStream != null && !_brsStream.isPaused) {
      _brsStream.pause();
    }
  }
}
