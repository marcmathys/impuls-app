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

  /// We only save the first value of the stimRatingRounds for the database,
  /// but we need some of the later values for the thresholds.
  /// This methods iterates through stimRatingRound1, takes the first values of each list of the current button pressed (0-10)
  /// and averages them with the corresponding value of stimRatingRound2.
  /// If a value was skipped, it averages with itself
  ///
  /// The thresholds are set in this method as follows:
  ///
  /// sensoryThreshold: First value of 0
  /// painThreshold: Final value of 1
  /// toleranceThreshold: First value of 10 (it's only one value)
  ///
  /// It is inefficient, but readable!
  void addRatingAndThresholds(Map<int, List<int>> stimRatingRound1, Map<int, List<int>> stimRatingRound2, int rounds, int determinationNumber) {
    Map<int, int> stimRatingAdjusted = {};

    if (rounds == 1) {
      stimRatingRound2 = stimRatingRound1;
    }

    /// In this step, we guarantee that every value is set. If one value isn't set, we just set it as the previous one.
    /// 0, 1 and 10 must be set!
    /// We utilize a loop for cleaner access to the previous value.
    for (int key = 0; key <= 10; key++) {
      if (stimRatingRound1[key].isEmpty) {
        stimRatingRound1[key] = stimRatingRound1[key - 1];
      }
    }

    for (int key = 0; key <= 10; key++) {
      if (stimRatingRound2[key].isEmpty) {
        stimRatingRound2[key] = stimRatingRound2[key - 1];
      }
    }

    /// Now we can average the values
    for (int key = 0; key <= 10; key++) {
      int average = (stimRatingRound1[key].first + stimRatingRound2[key].first) ~/ 2;
      stimRatingAdjusted[key] = average;
    }

    if (determinationNumber == 1) {
      state.stimRating1.addAll(stimRatingAdjusted.values);
    } else if (determinationNumber == 2) {
      state.stimRating2.addAll(stimRatingAdjusted.values);
    } else {
      state.stimRating3.addAll(stimRatingAdjusted.values);
    }

    /// And now we can add the thresholds:
    /// Reminder that they have 5 values;
    /// 1 + 2 from the first stimulation,
    /// 3 + 4 from the second and
    /// 5 from the final one, since this one is always only one round.
    if (determinationNumber == 3) {
      state.sensoryThreshold.addAll({stimRatingRound1[0].first});
      state.painThreshold.addAll({stimRatingRound1[1].last});
      state.toleranceThreshold.addAll({stimRatingRound1[10].first});
    } else {
      state.sensoryThreshold.addAll([stimRatingRound1[0].first, stimRatingRound2[0].first]);
      state.painThreshold.addAll([stimRatingRound1[1].last, stimRatingRound2[1].last]);
      state.toleranceThreshold.addAll([stimRatingRound1[10].first, stimRatingRound2[10].first]);
    }
  }
}
