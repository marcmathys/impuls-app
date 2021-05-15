import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/Entities/session.dart';

final sessionProvider = StateNotifierProvider<SessionState, Session>((ref) => SessionState(null));

class SessionState extends StateNotifier<Session> {
  SessionState(Session session) : super(null);

  setSession(Session session) {
    state = session;
  }

/** TODO void resetState() {
    currentPatient = null;
    currentSession = null;
    _currentStep = 0;
    }**/
}
