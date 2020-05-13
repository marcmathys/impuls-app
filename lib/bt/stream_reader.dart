//class StreamReader extends StatefulWidget {
//
//  @override
//  _StreamReaderState createState() => _StreamReaderState();
//}
//
//class _StreamReaderState extends State<StreamReader> {
//
//  StreamSubscription _subscription;
//
//  @override
//  void initState() {
//    super.initState();
//    _subscription = myStream.listen((data) {
//      // do whatever you want with stream data event here
//    });
//  }
//
//  @override
//  void dispose() {
//    _subscription?.cancel(); // don't forget to close subscription
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // return your widgets here
//  }
//}


//final FirebaseApp app = await FirebaseApp.configure(
//name: 'test',
//options: const FirebaseOptions(
//projectID: 'projid',
//googleAppID: 'appid',
//apiKey: 'api',
//databaseURL: 'your url',
//),
//);
//final Firestore firestore = Firestore(app: app);
//
//await firestore.settings(timestampsInSnapshotsEnabled: true);

//userPantry.updateData({'arrayName': FieldValue.arrayUnion(['element'])})

//Firestore.instance
//    .collection('YourCollection')
//.document('YourDocument')
//.updateData({'array':FieldValue.arrayUnion(['data1','data2','data3'])});

//Firestore.instance
//    .collection('YourCollection')
//.document('YourDocument')
//.setData({
//'array':FieldValue.arrayUnion(['data1','data2','data3'])
//}, merge: true);

