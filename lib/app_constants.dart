import 'package:flutter_blue/flutter_blue.dart';

class AppConstants {
  static final AppConstants _instance = AppConstants._internal();

  factory AppConstants() => _instance;

  AppConstants._internal();

  static Guid STIMULATION_UUID = Guid('9cb1af40-928a-11e9-bc42-526af7764f64');
  static Guid STIMULATION_CHARACTERISTIC_UUID = Guid('9cb1b21a-928a-11e9-bc42-526af7764f64');

  static Guid EKG_SERVICE_UUID = Guid('00b3b02e-928b-11e9-bc42-526af7764f64');
  static Guid EKG_CHARACTERISTIC_UUID = Guid('00b3b2ae-928b-11e9-bc42-526af7764f64');
  static Guid BPM_CHARACTERISTIC_UUID = Guid('df60bd72-ca66-11e9-a32f-2a2ae2dbcce4');

  static Guid ERROR_SERVICE = Guid('f74aa20e-ca66-11e9-a32f-2a2ae2dbcce4');
  static Guid ERROR_CHARACTERISTIC_UUID = Guid('2fe97344-e37e-11e9-81b4-2a2ae2dbcce4');

  static Guid BRS_SERVICE = Guid('59c22c3c-f0db-11e9-81b4-2a2ae2dbcce4');
  static Guid BRS_CHARACTERISTIC_UUID = Guid('61dc8462-f0db-11e9-81b4-2a2ae2dbcce4');

  static int EKG_LIST_LIMIT = 490;
  static int EKG_LIST_UPDATE_THRESHOLD = 10;
}
