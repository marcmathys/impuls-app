class AppConstants {
  static final AppConstants _instance = AppConstants._internal();
  factory AppConstants() => _instance;

  AppConstants._internal() {
    // init things inside this
  }
}