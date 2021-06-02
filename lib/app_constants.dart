import 'package:flutter_blue/flutter_blue.dart';

// ignore_for_file: non_constant_identifier_names
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

  static const int EKG_LIST_LIMIT = 500;
  static const int EKG_LIST_UPDATE_THRESHOLD = 10;

  /// A dictionary of the µA values and corresponding decimal values, so that the ESP stimulates with the correct voltage.
  /// Circumvents the inaccuracies of the fitting curve
  static const valueLookupTable = {
    0 : 200,
    200 : 790,
    400 : 688,
    600 : 626,
    800 : 581,
    1000 : 547,
    1200 : 520,
    1400 : 497,
    1600 : 476,
    1800 : 456,
    2000 : 439,
    2200 : 423,
    2400 : 408,
    2600 : 393,
    2800 : 380,
    3000 : 367,
    3200 : 355,
    3400 : 343,
    3600 : 332,
    3800 : 322,
    4000 : 313,
    4200 : 303,
    4400 : 294,
    4600 : 285,
    4800 : 277,
    5000 : 267,
    5200 : 262,
    5400 : 254,
    5600 : 247,
    5800 : 241,
    6000 : 234,
    6200 : 0,
    6400 : 0,
    6600 : 0,
    6800 : 0,
    7000 : 0,
    7200 : 0,
    7400 : 0,
    7600 : 0,
    7800 : 0,
    8000 : 0,
    8200 : 0,
    8400 : 0,
    8600 : 0,
    8800 : 0,
    9000 : 0,
    9200 : 0,
    9400 : 0,
    9600 : 0,
    9800 : 0,
    10000 : 0,
    10200 : 0,
    10400 : 0,
    10600 : 0,
    10800 : 0,
    11000 : 0,
    11200 : 0,
    11400 : 0,
    11600 : 0,
    11800 : 0,
    12000 : 0,
    12200 : 0,
    12400 : 0,
    12600 : 0,
    12800 : 0,
    13000 : 0,
    13200 : 0,
    13400 : 0,
    13600 : 0,
    13800 : 0,
    14000 : 0,
    14200 : 0,
    14400 : 0,
    14600 : 0,
    14800 : 0,
    15000 : 0,
    15200 : 0,
    15400 : 0,
    15600 : 0,
    15800 : 0,
    16000 : 0,
    16200 : 0,
    16400 : 0,
    16600 : 0,
    16800 : 0,
    17000 : 0,
    17200 : 0,
    17400 : 0,
    17600 : 0,
    17800 : 0,
    18000 : 0,
    18200 : 0,
    18400 : 0,
    18600 : 0,
    18800 : 0,
    19000 : 0,
    19200 : 0,
    19400 : 0,
    19600 : 0,
    19800 : 0,
    20000 : 0,
  };
}
