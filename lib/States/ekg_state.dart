import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';
import 'package:impulsrefactor/app_constants.dart';

class EkgState extends ChangeNotifier {
  List<MedicalData> ekgPoints = [MedicalData(0, 0)];

  void addEkgPoint(List<int> bluetoothData) {
    ByteData ekgByteData = ByteData.sublistView(Uint8List.fromList(bluetoothData.reversed.toList()));
    int ekgPoint = ekgByteData.getInt16(0, Endian.big);
    ekgPoints.add(MedicalData(ekgPoint, ekgPoints.last.xAxis + 1));

    if (ekgPoints.length > AppConstants.EKG_LIST_LIMIT) {
      ekgPoints.removeAt(0);
    }

    notifyListeners();
    /** if (updateCounter >= AppConstants.EKG_LIST_UPDATE_THRESHOLD) {
        if (_ekgPoints.length >= AppConstants.EKG_LIST_LIMIT + AppConstants.EKG_LIST_UPDATE_THRESHOLD) {
        _ekgPoints.removeRange(0, 10);
        _controller.updateDataSource(
        addedDataIndexes: List<int>.generate(AppConstants.EKG_LIST_UPDATE_THRESHOLD, (index) => AppConstants.EKG_LIST_LIMIT + index + 1),
        removedDataIndexes: List<int>.generate(AppConstants.EKG_LIST_UPDATE_THRESHOLD, (index) => index),
        );
        } else {
        _controller.updateDataSource(
        addedDataIndexes: List<int>.generate(AppConstants.EKG_LIST_UPDATE_THRESHOLD, (index) => _ekgPoints.length - index),
        );
        }
        updateCounter = 0;
        setState(() {});
        } **/
  }

  void resetEkgPoints() {
    ekgPoints.clear();
    ekgPoints.add(MedicalData(0,0));
  }
}