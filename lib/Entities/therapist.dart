class Therapist {
  static final Therapist _instance = Therapist._internal();
  factory Therapist() => _instance;

  Therapist._internal({this.address, this.approved, this.approvedTimestamp, this.clinicID, this.email, this.lastName, this.lastSession, this.moodleID, this.name, this.patients, this.phone});

  String address;
  bool approved;
  DateTime approvedTimestamp;
  String clinicID;
  String email;
  String espMac;
  String lastName;
  DateTime lastSession;
  String moodleID;
  String name;
  List<String> patients;
  String phone;
}
