class Session {
  int prePainRating;
  bool confirmed;
  DateTime confirmedDate;
  DateTime date;
  String deviceUID;
  String location;
  String notes;
  List<int> painThreshold;
  String patientUID;
  int postPainRating;
  List<int> sensoryThreshold;
  List<int> stimRating1;
  List<int> stimRating2;
  List<String> therapistUIDs;
  List<int> toleranceThreshold;
  String uid;

  Session({this.confirmedDate, this.confirmed, this.date, this.deviceUID, this.location, this.notes, this.painThreshold, this.patientUID, this.postPainRating,
      this.prePainRating, this.sensoryThreshold, this.stimRating1, this.stimRating2, this.therapistUIDs, this.toleranceThreshold});
}