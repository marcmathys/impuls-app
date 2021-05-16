import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/connected_device.dart';
import 'package:impulsrefactor/States/device_list.dart';
import 'package:impulsrefactor/States/error_service.dart';

class BluetoothDevicePicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final device = watch(connectedDeviceProvider);
    final deviceList = watch(deviceListProvider);

    return Column(
      children: [
        device != null
            ? Row(
                children: [
                  Text('Currently connected to: ${device?.id ?? 'none'} ${device?.name ?? ''}', style: Theme.of(context).textTheme.bodyText1),
                  ElevatedButton(
                    onPressed: () {
                      device.disconnect();
                      // TODO: Think how to elegantly do this: _btState.resetState();
                    },
                    child: Text('Disconnect', style: Theme.of(context).textTheme.bodyText1),
                  ),
                ],
              )
            : Text(
                'No device connected!', style: Theme.of(context).textTheme.bodyText1),
        ExpansionTile(
          title: Text('Expand to search for devices', style: Theme.of(context).textTheme.bodyText1),
          initiallyExpanded: false,
          onExpansionChanged: (isExpanded) {
            if (isExpanded) {
              context.read(deviceListProvider.notifier).scanForDevices();
            }
             else {
              context.read(deviceListProvider.notifier).stopScanning();
                }
          },
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: deviceList.length,
                itemBuilder: (builderContext, index) {
                  return ListTile(
                    title: Text('ID: ${deviceList.elementAt(index).id} ${deviceList.elementAt(index).name}', style: Theme.of(context).textTheme.bodyText1),
                    onTap: () async {
                      bool success = await context.read(connectedDeviceProvider.notifier).connectDevice(deviceList.elementAt(index));
                      if (success) {
                        context.read(errorServiceProvider.notifier).listenForErrors();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Device successfully connected', style: Theme.of(context).textTheme.bodyText1)));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
