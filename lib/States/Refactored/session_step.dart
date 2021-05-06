import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionStepProvider = StateNotifierProvider<SessionStep, int>((ref) => SessionStep(0));

class SessionStep extends StateNotifier<int> {
  SessionStep(int state) : super(0);

  void increment() => state++;

  void decrement() => state--;
}