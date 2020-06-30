import 'dart:convert';
import 'dart:typed_data';

import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';

class ByteConversion {
  static MedicalData ekgByteConversion(List<int> bluetoothData, BTState appState) {
    if (appState.ekgPoints.length >= 300) {
      appState.ekgPoints.removeAt(0);
    }
    ByteData ekgByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    int _ekgPoint = ekgByteData.getInt16(0, Endian.big);
    return MedicalData(DateTime.now(), _ekgPoint, appState.ekgPoints.last.xAxis + 1);
  }

  static double bpmByteConversion(List<int> bluetoothData) {
    ByteData bpmByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    return bpmByteData.getFloat32(0, Endian.big);
  }

  /// This method converts a string to an array of integers.
  /// The string is stripped from all spaces, and rejected if...
  /// - it contains non-digits
  /// - an integer is longer than 3 digits
  /// - an integer is bigger than 255 or smaller than 0
  static List<int> stringToHex(String hex) {
    List<int> hexList = List();
    hex.replaceAll(' ', '');

    if (hex.contains(RegExp('[^0-9,]+'))) {
      return [];
    }

    List<String> stringList = hex.split(',');
    stringList.forEach((element) {
      if (element.length != 3) {
        hexList.add(-1);
      } else {
        hexList.add(int.parse(element));
      }
    });

    for (int element in hexList) {
      if (element < 0 || element > 255) {
        return [];
      }
    }
    return hexList;
  }
}
