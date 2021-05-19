import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/States/bpm_service.dart';
import 'package:impulsrefactor/States/connected_device.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ekgServiceProvider = StateNotifierProvider<EkgServiceState, List<MedicalData>>((ref) => EkgServiceState([MedicalData(0, 0)], ref.read));

class EkgServiceState extends StateNotifier<List<MedicalData>> {
  final Reader read;
  StreamSubscription _ekgStream;

  EkgServiceState(List<MedicalData> data, this.read) : super([MedicalData(0, 0)]);

  bool isStreamRunning() {
    return _ekgStream != null ? !_ekgStream.isPaused : false;
  }

  /// Send "on" to the ekg and bpm characteristic and starts listening for values
  void startDataStreams() async {
    if (read(connectedDeviceProvider) == null) {
      print('Device is not connected!');
      return;
    }

    if (!read(connectedDeviceProvider.notifier).characteristics.containsKey(AppConstants.EKG_CHARACTERISTIC_UUID)) {
      print('Characteristic EKG not found!');
      return;
    }

    BluetoothCharacteristic ekgCharacteristic = read(connectedDeviceProvider.notifier).characteristics[AppConstants.EKG_CHARACTERISTIC_UUID];

    await sendOnSignal();

    if (_ekgStream == null) {
      _ekgStream = ekgCharacteristic.value.listen((event) {
        addEkgPoint(event);
      });
      await ekgCharacteristic.setNotifyValue(true);
    }

    read(bpmServiceProvider.notifier).startBpmStream();

    resumeListenToEkg();
  }

  /// Sends "on" as integer values to the ekg service
  Future sendOnSignal() async {
    BluetoothCharacteristic ekgCharacteristic = read(connectedDeviceProvider.notifier).characteristics[AppConstants.EKG_CHARACTERISTIC_UUID];

    if (ekgCharacteristic == null) {
      return;
    }
    await ekgCharacteristic.write([111, 110]);
  }

  /// Sends "off" as integer values to the ekg service
  Future sendOffSignal() async {
    BluetoothCharacteristic ekgCharacteristic = read(connectedDeviceProvider.notifier).characteristics[AppConstants.EKG_CHARACTERISTIC_UUID];

    if (ekgCharacteristic == null) {
      return;
    }
    await ekgCharacteristic.write([111, 102, 102]);
  }

  void addEkgPoint(List<int> bluetoothData) {
    ByteData ekgByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    int ekgPoint = ekgByteData.getInt16(0, Endian.big);
    state.add(MedicalData(ekgPoint, state.last.xAxis + 1));

    if (state.length > AppConstants.EKG_LIST_LIMIT) {
      state.removeAt(0);
    }
    state = state; // Because editing a list doesn't notify the listeners
  }

  void resetEkgPoints() {
    state.clear();
    state.add(MedicalData(0, 0));
  }

  void resumeListenToEkg() {
    if (_ekgStream != null && _ekgStream.isPaused) {
      _ekgStream.resume();
    }
  }

  void pauseListenToEkg() {
    if (_ekgStream != null && !_ekgStream.isPaused) {
      _ekgStream.pause();
    }
  }
}
