import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/Entities/fitting_curve.dart';
import 'package:impulsrefactor/Entities/fitting_point.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FittingCurveCalculator {
  static Future<PolynomialFit> calculate(List<FittingPoint> points) async {
    List<double> xValues = points.map((point) => point.decimalValue.toDouble()).toList();
    List<double> yValues = points.map((point) => point.volt).toList();

    LeastSquaresSolver leastSquaresSolver = LeastSquaresSolver(xValues, yValues, List.generate(xValues.length, (index) => 1));
    PolynomialFit solve = leastSquaresSolver.solve(1);

    return solve;
  }

  static int fitToCurve(int value) {
    List<double> fittingCurve = FittingCurve.getFittingCurveCoefficients();

    if (fittingCurve != null) {
      return ((log(value) - fittingCurve[0]) / fittingCurve[1]).round();
    } else {
      Get.snackbar('Error', 'Fitting curve settings not found!');
      return -1;
    }
  }

  static List<FittingPoint> performDeepCopy(List<FittingPoint> listToCopy) {
    List<FittingPoint> copy = [];

    listToCopy.forEach((fittingPoint) {
      copy.add(FittingPoint(fittingPoint.decimalValue, fittingPoint.volt));
    });

    return copy;
  }
}
