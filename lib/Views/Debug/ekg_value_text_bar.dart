import 'package:flutter/material.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:provider/provider.dart';

class EKGValueTextBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<BtState, String>(
              selector: (_, state) => state.stimulation.toString(),
              builder: (_, stimulation, __) {
                return Text('Stimulation characteristic answer: $stimulation');
              }),
          Selector<BtState, String>(
              selector: (_, state) => state.bpm.toStringAsFixed(2),
              builder: (_, bpm, __) {
                return Text('Beats per minute: $bpm');
              }),
          Selector<BtState, String>(
              selector: (_, state) => state.error.toString(),
              builder: (_, error, __) {
                return Text('Error code: $error');
              }),
          Selector<BtState, String>(
              selector: (_, state) => state.brs.toString(),
              builder: (_, brs, __) {
                return Text('Baur Reflex Sensitivity: $brs');
              }),
        ],
      ),
    );
  }
}
