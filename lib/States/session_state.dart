import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/Entities/therapist.dart';
import 'package:impulsrefactor/States/current_patient.dart';
import 'package:impulsrefactor/States/session_step.dart';

final sessionProvider = StateNotifierProvider<SessionState, Session>((ref) => SessionState(null, ref));

class SessionState extends StateNotifier<Session> {
  ProviderReference ref;

  SessionState(Session session, this.ref) : super(null);

  void setSession(Session session) {
    state = session;
  }

  void startNewSession() {
    Session session = Session();
    session.confirmed = false;
    session.date = DateTime.now();
    session.patientUID = ref.read(currentPatientProvider).uid;
    session.therapistUIDs.add(Therapist().uid);
    state = session;
  }

  void addThresholds(Map<int, int> stimRatingRound1, Map<int, int> stimRatingRound2, int rounds) {
    if (rounds == 2) {
      stimRatingRound1.forEach((key, value) {
        int average = (value + stimRatingRound2[key]) ~/ 2;
        if (ref.read(sessionProvider).stimRating1.isEmpty) {
          ref.read(sessionProvider).stimRating1.add(average);
        } else if (ref.read(sessionProvider).stimRating2.isEmpty) {
          ref.read(sessionProvider).stimRating2.add(average);
        } else if (ref.read(sessionProvider).stimRating3.isEmpty) {
          ref.read(sessionProvider).stimRating3.add(average);
        }

        ref.read(sessionProvider).sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound2[0]});
        ref.read(sessionProvider).painThreshold.addAll({stimRatingRound1[1], stimRatingRound2[1]});
        ref.read(sessionProvider).toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound2[10]});
      });
    } else {
      stimRatingRound1.forEach((key, value) {
        if (ref.read(sessionProvider).stimRating1.isEmpty) {
          ref.read(sessionProvider).stimRating1.add(value);
        } else if (ref.read(sessionProvider).stimRating2.isEmpty) {
          ref.read(sessionProvider).stimRating2.add(value);
        } else if (ref.read(sessionProvider).stimRating3.isEmpty) {
          ref.read(sessionProvider).stimRating3.add(value);
        }

        ref.read(sessionProvider).sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound1[0]});
        ref.read(sessionProvider).painThreshold.addAll({stimRatingRound1[1], stimRatingRound1[1]});
        ref.read(sessionProvider).toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound1[10]});
      });
    }
    ref.read(sessionStepProvider.notifier).increment();
  }

/** TODO void resetState() {
    currentPatient = null;
    currentSession = null;
    _currentStep = 0;
    }**/
}
