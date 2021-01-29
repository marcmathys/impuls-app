import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:impulsrefactor/Entities/fitting_point.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FittingCurveCalculator {
  static Future<PolynomialFit> calculate(List<FittingPoint> points) async {
    List<double> xValues = points.map((point) => point.x.toDouble()).toList();
    List<double> yValues = points.map((point) => point.y).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    LeastSquaresSolver leastSquaresSolver = LeastSquaresSolver(xValues, yValues, List.generate(xValues.length, (index) => 1));
    PolynomialFit solve = leastSquaresSolver.solve(1);

    prefs.setDouble('fittingCurveFirstCoefficient', solve.coefficients.first);
    prefs.setDouble('fittingCurveSecondCoefficient', solve.coefficients.elementAt(1));

    return solve;
  }

  static Future<int> fitToCurve(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('fittingCurveFirstCoefficient') && prefs.containsKey('fittingCurveSecondCoefficient')) {
      double firstCoefficient = prefs.getDouble('fittingCurveFirstCoefficient');
      double secondCoefficient = prefs.getDouble('fittingCurveSecondCoefficient');

      return ((log(value) - firstCoefficient) / secondCoefficient).round();
    } else {
      print('Fitting curve settings not found!');
      return null;
    }
  }
}
