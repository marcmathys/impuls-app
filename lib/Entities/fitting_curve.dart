import 'package:shared_preferences/shared_preferences.dart';

class FittingCurve {
  static Map<String, double> _fittingCurveCoefficients = {};

  static Future<void> setFittingCurveCoefficient(Map<String, double> fittingCurveCoefficients) async {
    _fittingCurveCoefficients = fittingCurveCoefficients;
    await saveFittingCurve();
  }

  static Map<String, double> getFittingCurveCoefficients() {
    if (_fittingCurveCoefficients.containsKey('first') && (_fittingCurveCoefficients.containsKey('second'))) {
      return _fittingCurveCoefficients;
    } else
      return null;
  }

  static Future<void> loadFittingCurve() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('fittingCurveFirstCoefficient') && prefs.containsKey('fittingCurveSecondCoefficient')) {
      _fittingCurveCoefficients['first'] = prefs.getDouble('fittingCurveFirstCoefficient');
      _fittingCurveCoefficients['second'] = prefs.getDouble('fittingCurveSecondCoefficient');
    }
  }

  static Future<void> saveFittingCurve() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fittingCurveFirstCoefficient', _fittingCurveCoefficients['first']);
    prefs.setDouble('fittingCurveSecondCoefficient', _fittingCurveCoefficients['second']);
  }

  static Future<void> resetFittingCurve({bool persist = false}) async {
    _fittingCurveCoefficients.clear();

    if (persist) {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('fittingCurveFirstCoefficient') && prefs.containsKey('fittingCurveSecondCoefficient')) {
        prefs.remove('fittingCurveFirstCoefficient');
        prefs.remove('fittingCurveSecondCoefficient');
      }
    }
  }
}