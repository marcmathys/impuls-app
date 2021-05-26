import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/Entities/therapist.dart';
import 'package:impulsrefactor/States/current_patient.dart';
import 'package:impulsrefactor/States/session_step.dart';

final sessionProvider = StateNotifierProvider<SessionState, Session>((ref) => SessionState(ref));

class SessionState extends StateNotifier<Session> {
  ProviderReference ref;

  SessionState(this.ref) : super(null) {
    state = Session();
    state.confirmed = false;
    state.date = DateTime.now();
    state.patientUID = ref.read(currentPatientProvider).uid;
    state.therapistUIDs.add(Therapist().uid);
  }

  void resetSession() {
    Session session = Session();
    session.confirmed = false;
    session.date = DateTime.now();
    session.patientUID = ref.read(currentPatientProvider).uid;
    session.therapistUIDs.add(Therapist().uid);
    state = session;
  }

  void abandonSession() {
    resetSession();
    ref.read(currentPatientProvider.notifier).unsetPatient();
    ref.read(sessionStepProvider.notifier).resetStep();
  }

  void addThresholds(Map<int, int> stimRatingRound1, Map<int, int> stimRatingRound2, int rounds) {
    if (rounds == 2) {
      stimRatingRound1.forEach((key, value) {
        int average = (value + stimRatingRound2[key]) ~/ 2;
        if (state.stimRating1.isEmpty) {
          state.stimRating1.add(average);
        } else if (state.stimRating2.isEmpty) {
          state.stimRating2.add(average);
        } else if (state.stimRating3.isEmpty) {
          state.stimRating3.add(average);
        }

        state.sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound2[0]});
        state.painThreshold.addAll({stimRatingRound1[1], stimRatingRound2[1]});
        state.toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound2[10]});
      });
    } else {
      stimRatingRound1.forEach((key, value) {
        if (state.stimRating1.isEmpty) {
          state.stimRating1.add(value);
        } else if (state.stimRating2.isEmpty) {
          state.stimRating2.add(value);
        } else if (state.stimRating3.isEmpty) {
          state.stimRating3.add(value);
        }

        state.sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound1[0]});
        state.painThreshold.addAll({stimRatingRound1[1], stimRatingRound1[1]});
        state.toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound1[10]});
      });
    }
    ref.read(sessionStepProvider.notifier).increment();
  }
}
