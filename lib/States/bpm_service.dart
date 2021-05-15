import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/States/Refactored/connected_device.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bpmServiceProvider = StateNotifierProvider<BpmServiceState, double>((ref) => BpmServiceState(0.0, ref.read));

class BpmServiceState extends StateNotifier<double> {
  final Reader read;
  StreamSubscription _bpmStream;

  BpmServiceState(double bpm, this.read) : super(0.0);

  void startBpmStream() async {
    BluetoothCharacteristic bpmCharacteristic = read(connectedDeviceProvider.notifier).characteristics[AppConstants.BPM_CHARACTERISTIC_UUID];

    if (_bpmStream == null) {
      _bpmStream = bpmCharacteristic.value.listen((event) {
        if (event.length == 4) {
          state = ByteConversion.bpmByteConversion(event);
        }
      });
      await bpmCharacteristic.setNotifyValue(true);
    }
  }

  void resumeListenToBpm() {
    if (_bpmStream != null && _bpmStream.isPaused) {
      _bpmStream.resume();
    }
  }

  void pauseListenToBpm() {
    if (_bpmStream != null && !_bpmStream.isPaused) {
      _bpmStream.pause();
    }
  }
}
