import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Views/Components/components.dart';
import 'package:impulsrefactor/Views/Components/pain_level_chart_component.dart';
import 'package:impulsrefactor/Views/Components/stimulation_level_chart_component.dart';

class PatientDetail extends StatefulWidget {
  Patient _patient;
  final List<String> _sessions = ['29.01.2020', '02.02.2020', '07.02.2020', '14.02.2020']; //TODO: Mock data, take real dates

  @override
  _PatientDetailState createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget._patient = ModalRoute.of(context).settings.arguments;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components.appBar('Sessions of ${widget._patient.patientCode}'),
      body: Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(flex: 1, child: RaisedButton(onPressed: () => null, child: Text('Show last session'))),
              Flexible(flex: 1, child: DropdownButton<String>(value: widget._sessions.last, items: widget._sessions.map((sessionDate) {return DropdownMenuItem<String>(value: sessionDate, child: Text(sessionDate));}).toList(), onChanged: (_) => null,)),
              Flexible(flex: 1, child: RaisedButton(onPressed: () => Navigator.of(context).pushNamed('/session_stepper'), child: Text('Start new session'))),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(child: StimulationLevelChart()),
            Flexible(child: PainLevelChart()),
          ],
          ),
        ],
      ),
    );
  }
}