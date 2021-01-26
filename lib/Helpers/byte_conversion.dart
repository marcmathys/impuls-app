import 'dart:typed_data';

class ByteConversion {
  static double bpmByteConversion(List<int> bluetoothData) {
    ByteData bpmByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    return bpmByteData.getFloat32(0, Endian.big);
  }

  static List<int> convertFloatToByteList(double value) {
    ByteData data = ByteData(4);
    data.setFloat32(0, value);
    return data.buffer.asUint8List().toList();
  }

  /// This method converts a string to an array of integers.
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
