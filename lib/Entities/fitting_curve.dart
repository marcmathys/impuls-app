import 'package:shared_preferences/shared_preferences.dart';

class FittingCurve {
  static List<double> _fittingCurveCoefficients = [];

  static Future<void> setFittingCurveCoefficient(List<double> fittingCurveCoefficients) async {
    _fittingCurveCoefficients = fittingCurveCoefficients;
    await saveFittingCurve();
  }

  static List<double> getFittingCurveCoefficients() {
    if (_fittingCurveCoefficients.length == 2) {
      return _fittingCurveCoefficients;
    } else
      return null;
  }

  static Future<void> loadFittingCurve() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('fittingCurveFirstCoefficient') && prefs.containsKey('fittingCurveSecondCoefficient')) {
      _fittingCurveCoefficients[0] = prefs.getDouble('fittingCurveFirstCoefficient');
      _fittingCurveCoefficients[1] = prefs.getDouble('fittingCurveSecondCoefficient');
    }
  }

  static Future<void> saveFittingCurve() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fittingCurveFirstCoefficient', _fittingCurveCoefficients[0]);
    prefs.setDouble('fittingCurveSecondCoefficient', _fittingCurveCoefficients[1]);
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
