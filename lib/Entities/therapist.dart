class Therapist {
  static final Therapist _instance = Therapist._internal();
  factory Therapist() => _instance;

  Therapist._internal({this.address, this.approved, this.approvedTimestamp, this.clinicID, this.email, this.lastName, this.moodleID, this.name, this.phone, this.uid});

  String address;
  bool approved;
  DateTime approvedTimestamp;
  String clinicID;
  String email;
  String espMac;
  String lastName;
  String moodleID;
  String name;
  String phone;
  String uid;
}
