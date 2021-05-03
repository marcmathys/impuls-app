class Calculator {
  static double roundDoubleToPrecision(double value, int precision) {
    return double.parse(value.toStringAsFixed(precision));
  }

  static double calculateIBI(double bpm) {
    if (bpm == 0.0) {
      return 0.0;
    }
    return roundDoubleToPrecision((60 / roundDoubleToPrecision(bpm, 2) * 1000), 2);
  }

  static double calculateMeanOfList(List<int> values){
    double mean = 0.0;
    values.forEach((element) {mean += element;});
    return mean / values.length;
  }
}
