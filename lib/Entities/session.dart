class Session {
  int prePainRating; // Subjective value given by the patient at the beginning of the session
  bool confirmed;
  DateTime confirmedDate;
  DateTime date;
  String deviceUID;
  String location;
  String notes;
  List<int> painThreshold = []; // A list of 5 values: 2 values each for the first and second stimulation round, and one for the final one
  String patientUID;
  int postPainRating; // Subjective value given by the patient at the end of the session
  List<int> sensoryThreshold = []; // A list of 5 values: 2 values each for the first and second stimulation round, and one for the final one
  List<int> stimRating1 = []; // Round 1
  List<int> stimRating2 = []; // Round 2
  List<int> stimRating3 = []; // Round 3
  List<String> therapistUIDs = [];
  List<int> toleranceThreshold = []; // A list of 5 values: 2 values each for the first and second stimulation round, and one for the final one
  String uid;
}