import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/Refactored/bpm_service.dart';
import 'package:impulsrefactor/States/Refactored/brs_service.dart';
import 'package:impulsrefactor/States/Refactored/error_service.dart';
import 'package:impulsrefactor/States/Refactored/stimulation_service.dart';

class EKGValueTextBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(builder: (context, watch, child) {
            String stimulationValue = watch(stimulationServiceProvider).toString();
            return Text('Stimulation characteristic answer: $stimulationValue');
          }),
          Consumer(builder: (context, watch, child) {
            String bpmValue = watch(bpmServiceProvider).toStringAsFixed(2);
            return Text('Beats per minute: $bpmValue');
          }),
          Consumer(builder: (context, watch, child) {
            String errorString = watch(errorServiceProvider).toString();
            return Text('Error code: $errorString');
          }),
          Consumer(builder: (context, watch, child) {
            String brsValue = watch(brsServiceProvider).toString();
            return Text('Baur Reflex Sensitivity: $brsValue');
          }),
        ],
      ),
    );
  }
}
