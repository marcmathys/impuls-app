import 'package:flutter/material.dart';
import 'package:impulsrefactor/Views/Components/chart_component.dart';
import 'package:impulsrefactor/Views/Components/components.dart';
import 'package:impulsrefactor/bluetooth_handler.dart';

class Debug extends StatefulWidget {
  @override
  _DebugState createState() => _DebugState();
}

class _DebugState extends State<Debug> {
  BluetoothHandler _handler;

  @override
  void initState() {
    super.initState();
    _handler = BluetoothHandler();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components.appBar('Hello, master!'),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(child: Chart('EKG')),
                Flexible(child: Chart('IBI')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    _handler.scanForDevices().then((code) => Components.loginErrorSnackBar(context, code));
                  },
                  child: Text('Connect'),
                ),
                RaisedButton(
                  onPressed: () {
                    _handler.disconnectDevice();
                  },
                  child: Text('Disconnect'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.getEKGData(),
                    child: Text('Get EKG Data'),
                  ),
                ),
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.sendOffSignal(_handler.ekgSubscription),
                    child: Text('Stop EKG'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.getIBIData(),
                    child: Text('Get IBI Data'),
                  ),
                ),
                Flexible(
                  child: RaisedButton(
                    onPressed: () => _handler.ibiSubscription.cancel(),
                    child: Text('Stop IBI subscription'),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
