class Session {
  int prePainRating;
  bool confirmed;
  DateTime confirmedDate;
  DateTime date;
  String deviceUID;
  String location;
  String notes;
  List<int> painThreshold = [];
  String patientUID;
  int postPainRating;
  List<int> sensoryThreshold = [];
  List<int> stimRating1 = [];
  List<int> stimRating2 = [];
  List<int> stimRating3 = [];
  List<String> therapistUIDs = [];
  List<int> toleranceThreshold = [];
  String uid;
}