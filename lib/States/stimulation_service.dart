import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/connected_device.dart';
import 'package:impulsrefactor/app_constants.dart';

final stimulationServiceProvider = StateNotifierProvider<StimulationServiceState, List<int>>((ref) => StimulationServiceState([], ref.read));

class StimulationServiceState extends StateNotifier<List<int>> {
  final Reader read;
  StreamSubscription _stimulation;

  StimulationServiceState(List<int> stimulationValue, this.read) : super(stimulationValue ?? []);

  /// Sends the given integers representing bytes to the stimulation characteristic
  /// Note that the stimulation characteristic supports 3 and 7 integer values, and "quit" in integer
  /// Starts listening for values
  void sendStimulationBytes(List<int> bytes) async {
    if (read(connectedDeviceProvider) == null) {
      print('Device is not connected!');
      return;
    }

    if (!read(connectedDeviceProvider.notifier).characteristics.containsKey(AppConstants.STIMULATION_CHARACTERISTIC_UUID)) {
      print('Characteristic Stimulation not found!');
      return;
    }

    BluetoothCharacteristic stimulation = read(connectedDeviceProvider.notifier).characteristics[AppConstants.STIMULATION_CHARACTERISTIC_UUID];
    await stimulation.write(bytes);

    if (bytes == [113, 117, 105, 116]) {
      _stimulation.pause();
      return;
    }
    if (_stimulation == null) {
      _stimulation = stimulation.value.listen((event) {
        state = event;
      });
      await stimulation.setNotifyValue(true);
    }
    if (_stimulation.isPaused) {
      _stimulation.resume();
    }
  }
}
