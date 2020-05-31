// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:implulsnew/styles/button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:implulsnew/bt/Bluetooth_screen.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:isolate_handler/isolate_handler.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(result.rssi.toString()),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
      children: <Widget>[
        _buildAdvRow(
            context, 'Complete Local Name', result.advertisementData.localName),
        _buildAdvRow(context, 'Tx Power Level',
            '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(
            context,
            'Manufacturer Data',
            getNiceManufacturerData(
                    result.advertisementData.manufacturerData) ??
                'N/A'),
        _buildAdvRow(
            context,
            'Service UUIDs',
            (result.advertisementData.serviceUuids.isNotEmpty)
                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),
        _buildAdvRow(context, 'Service Data',
            getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'),
      ],
    );
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key key, this.service, this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Service C'),
            Text('0x${service.uuid.toString()}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Theme.of(context).textTheme.caption.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: Text('Service'),
        subtitle: Text('0x${service.uuid.toString()}'),
      );
    }
  }
}

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  const CharacteristicTile(
      {Key key,
      this.characteristic,
      this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  _CharacteristicTileState createState() => _CharacteristicTileState();
}


class _CharacteristicTileState extends State<CharacteristicTile> {
  final List<MedicalData> _chartData = [
    MedicalData(DateTime.now(), 0),
  ];
  final _listData = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: widget.characteristic.value,
      initialData: widget.characteristic.lastValue,
      builder: (c, snapshot) {
        var _btData = snapshot.data;

        byteConversion(_btData);

        return buildColumn(context, snapshot);
      },
    );
  }

  void byteConversion(List<int> _btData) {
    print(_btData);
    if (_btData.length == 2) {
      if (_chartData.length > 300) {
        _chartData.removeAt(0);
      }
      ByteData bytedata1 = ByteData.sublistView(
          Uint8List.fromList(_btData.reversed.toList()));
      print(bytedata1);
      int _ekgPoint = bytedata1.getInt16(0, Endian.big);
      print(_ekgPoint);
    
      _chartData.add(MedicalData(DateTime.now(), _ekgPoint));
    } else if (_btData.length == 4) {
      ByteData bytedata2 = ByteData.sublistView(
          Uint8List.fromList(_btData.reversed.toList()));
      print(bytedata2);
      if (widget.characteristic.serviceUuid.toString() ==
          '00b3b02e-928b-11e9-bc42-526af7764f64') {
        double _ibiPoint = bytedata2.getFloat32(0, Endian.big);
        print(_ibiPoint);
        _listData.add(_ibiPoint);
      } else {
        int _countDown = bytedata2.getUint32(0, Endian.big);
        print(_countDown);
        _listData.add(_countDown);
      }
    }
    print(_chartData[0].dateTime);
  }

  Column buildColumn(BuildContext context, AsyncSnapshot<List<int>> snapshot) {
    return Column(
        children: <Widget>[
          ExpansionTile(
            title: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.characteristic.uuid
                          .toString()
                          .contains('526af7764f64')
                      ? 'EKG'
                      : ''),
                  Text(widget.characteristic.uuid
                          .toString()
                          .contains('df60bd72')
                      ? 'IBI'
                      : ''),
                  Text('${widget.characteristic.uuid.toString()}',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).textTheme.caption.color))
                ],
              ),
              subtitle: Text(snapshot.data.toString()),
              contentPadding: EdgeInsets.all(0.0),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 40,
                ),
                IconButton(
                  icon: Icon(Icons.edit,
                      color:
                          Theme.of(context).iconTheme.color.withOpacity(0.5)),
                  onPressed: widget.onWritePressed,
                ),
                Text('W'),
                SizedBox(
                  width: 40,
                ),
                IconButton(
                  icon: Icon(
                      widget.characteristic.isNotifying
                          ? Icons.sync_disabled
                          : Icons.sync,
                      color:
                          Theme.of(context).iconTheme.color.withOpacity(0.5)),
                  onPressed: widget.onNotificationPressed,
                ),
                ButtonButton(
                  onPressed: () async {
                    Text('pressed');
                    Text('$writeToDeviceBytes()');
                  },
                  child: Container(
                    width: 300,
                    color: Colors.indigo.shade50,
                    child: TextField(
                      onChanged: (text) {
                        writeInput = text;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: "Choose Service, then W",
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ],
            ),
            children: widget.descriptorTiles,
          ),
          (snapshot.data.length == 2)
              ? Chart(chartData: _chartData)
              : ScrollList(listData: _listData),
        ],
      );
  }
}

class Chart extends StatefulWidget {
  const Chart({
    Key key,
    @required List<MedicalData> chartData,
  })  : _chartData = chartData,
        super(key: key);

  final List<MedicalData> _chartData;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
//      zoomPanBehavior:
//          ZoomPanBehavior(enablePinching: true, enablePanning: true),
      primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      series: <ChartSeries<MedicalData, DateTime>>[
        LineSeries<MedicalData, DateTime>(
          name: 'EKG',
          dataSource: widget._chartData,
          xValueMapper: (MedicalData medicalData, _) => medicalData.dateTime,
          yValueMapper: (MedicalData medicalData, _) =>
              medicalData.ekgPoint.toDouble(),
          animationDuration: 0,
          dataLabelSettings: DataLabelSettings(
              isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
        ),
      ],
    );
  }
}

class MedicalData {
  MedicalData(this.dateTime, this.ekgPoint);

  final DateTime dateTime;
  final num ekgPoint;
}

class ScrollList extends StatelessWidget {
  const ScrollList({
    Key key,
    @required List listData,
  })  : _listData = listData,
        super(key: key);

  final List _listData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 30,
          reverse: true,
          itemBuilder: (BuildContext ctxt, int index) {
            return Container(
                height: 30,
                child: Text((_listData != [] ? '$_listData' : '')));
          }),
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;

  const DescriptorTile(
      {Key key,
      this.descriptor,
        this.onReadPressed,
      this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Descriptor'),
          Text('0x${descriptor.uuid.toString()}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Theme.of(context).textTheme.caption.color))
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.value,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),

          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key key, @required this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subtitle1.color,
        ),
      ),
    );
  }
}
