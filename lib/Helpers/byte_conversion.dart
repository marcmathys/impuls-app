import 'dart:typed_data';

import 'package:get/get.dart';

class ByteConversion {
  static double bpmByteConversion(List<int> bluetoothData) {
    ByteData bpmByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    return bpmByteData.getFloat32(0, Endian.big);
  }

  /// Integer value needs to be between 0 and 1023
  static List<int> convertIntToByteList(int value) {
    if (value < 0 || value > 1023) {
      Get.snackbar('Format error', 'Value must be between 0 and 1023');
      return [];
    }

    ByteData data = ByteData(3);
    data.setInt16(1, value, Endian.big);
    return data.buffer.asUint8List().toList();
  }

  static List<int> convertThresholdsToByteList(List<int> sensoryThreshold, List<int> painThreshold, List<int> toleranceThreshold) {
    int sensory = sensoryThreshold[0] + sensoryThreshold[1] ~/2;
    int pain = painThreshold[0] + painThreshold[1] ~/2;
    int tolerance = toleranceThreshold[0] + toleranceThreshold[1] ~/2;

    int dt = sensory;
    int htt = pain + (tolerance - pain) ~/ 2;
    int tt = (pain + (tolerance - pain) * 0.75).round();

    ByteData data = ByteData(7);
    /**data.setUint16(1, dt, Endian.big);
    data.setUint16(3, htt, Endian.big);
    data.setUint16(5, tt, Endian.big);**/
    //TODO: Reinstate. Commented out because of fitting curve uncertainties and we need to test
    data.setUint16(1, 0, Endian.big);
    data.setUint16(3, 256, Endian.big);
    data.setUint16(5, 512, Endian.big);
    return data.buffer.asUint8List().toList();
  }

  /// Ths method converts a string to an array of integers.
  /// The string is stripped from all spaces, and rejected if...
  /// - it contains non-digits
  /// - an integer is longer than 3 digits
  /// - an integer is bigger than 255 or smaller than 0
  static List<int> stringToOct(String oct) {
    List<int> octList = [];
    oct.replaceAll(' ', '');

    if (oct.contains(RegExp('[^0-9,]+'))) {
      return [];
    }

    List<String> stringList = oct.split(',');
    stringList.forEach((element) {
      if (element.length > 3) {
        octList.add(-1);
      } else {
        octList.add(int.parse(element));
      }
    });

    for (int element in octList) {
      if (element < 0 || element > 255) {
        return [];
      }
    }
    return octList;
  }
}
