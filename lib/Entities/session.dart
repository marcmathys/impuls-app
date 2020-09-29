class Session {
  DateTime confirmDate;
  bool confirmed;
  DateTime date;
  String device;
  String location;
  String notes;
  List<int> painThreshold;
  int patientID;
  int patientUID;
  int postPainRating;
  int prePainRating;
  List<int> sensoryThreshold;
  List<int> stimRating;
  String therapistID;
  String therapistUID;
  List<int> toleranceThreshold;

  Session({this.confirmDate, this.confirmed, this.date, this.device, this.location, this.notes, this.painThreshold, this.patientID, this.patientUID, this.postPainRating,
      this.prePainRating, this.sensoryThreshold, this.stimRating, this.therapistID, this.therapistUID, this.toleranceThreshold});
}