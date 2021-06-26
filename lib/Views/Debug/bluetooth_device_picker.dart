import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/connected_device.dart';
import 'package:impulsrefactor/States/device_list.dart';
import 'package:impulsrefactor/Style/themes.dart';

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
                  Text('Currently connected to: ${device?.id ?? 'none'} ${device?.name ?? ''}', style: Themes.getSmallTextStyle()),
                  ElevatedButton(
                    onPressed: () {
                      device.disconnect();
                      // TODO: Think how to elegantly do this: _btState.resetState();
                    },
                    child: Text('Disconnect', style: Themes.getButtonTextStyle()),
                  ),
                ],
              )
            : Text('No device connected!', style: Themes.getErrorTextStyle()),
        ExpansionTile(
          title: Text('Expand to search for devices', style: Themes.getDefaultTextStyle()),
          initiallyExpanded: false,
          onExpansionChanged: (isExpanded) {
            if (isExpanded) {
              context.read(deviceListProvider.notifier).scanForDevices();
            } else {
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
                      title: Text('ID: ${deviceList.elementAt(index).id} ${deviceList.elementAt(index).name}', style: Themes.getDefaultTextStyle()),
                      onTap: () {
                        context.read(connectedDeviceProvider.notifier).connectDevice(deviceList.elementAt(index));
                      });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
