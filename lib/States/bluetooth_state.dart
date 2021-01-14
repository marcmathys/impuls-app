import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BTState extends ChangeNotifier {
  static final BTState _instance = BTState._internal();

  factory BTState() => _instance;

  BTState._internal();

  BluetoothDevice _device;
  Map<Guid, BluetoothCharacteristic> _characteristics = {};
  double _bpm = 0.0;
  int _brs;
  List<int> _error = [];
  List<int> _stimulation = [];
  List<BluetoothDevice> _scannedDevices = [];

  void resetState() {
    if (_device != null) {
      _device.disconnect();
    }
    _device = null;
    _characteristics.clear();
    _bpm = 0.0;
    _brs = null;
    _error.clear();
    _stimulation.clear();
    _scannedDevices.clear();
    notifyListeners();
  }

  List<BluetoothDevice> get scannedDevices => _scannedDevices;

  set device(BluetoothDevice device) {
    _device = device;
    notifyListeners();
  }

  BluetoothDevice get device => _device;

  void setDeviceList(List<BluetoothDevice> devices) {
    _scannedDevices.clear();
    _scannedDevices.addAll(devices);
    notifyListeners();
  }

  void resetScannedDevicesList() {
    this._scannedDevices.clear();
    notifyListeners();
  }

  List<int> get error => _error;

  void addError(int value) {
    if (_error.length >= 10) {
      _error.removeAt(0);
    }

    _error.add(value);
    notifyListeners();
  }

  List<int> get stimulation => _stimulation;

  set stimulation(List<int> value) {
    _stimulation = value;
    notifyListeners();
  }

  int get brs => _brs;

  set brs(int value) {
    _brs = value;
    notifyListeners();
  }

  Map<Guid, BluetoothCharacteristic> get characteristics => _characteristics;

  set characteristics(Map<Guid, BluetoothCharacteristic> value) {
    _characteristics = value;
  }

  double get bpm => _bpm;

  set bpm(double value) {
    _bpm = value;
    notifyListeners();
  }
}
