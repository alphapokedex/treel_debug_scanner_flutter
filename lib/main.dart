import 'dart:async';
import 'dart:developer';

import 'package:demo/conversion_utils.dart';
import 'package:demo/treel_beacon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ble Treel',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

const String _serviceUuid = '0000ffe0-0000-1000-8000-00805f9b34fb';
const String _anotherUuid = '0000fff0-0000-1000-8000-00805f9b34fb';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription _subscription;

  final List _devicesData = [];

  Future<void> _startScan(BuildContext context) async {
    var _btStatus = await Permission.bluetooth.request().isGranted;
    var _locStatus = await Permission.location.request().isGranted;
    var bluetoothConnectStatus =
        await Permission.bluetoothConnect.request().isGranted;
    var scanStatus = await Permission.bluetoothScan.request().isGranted;

    if (scanStatus && bluetoothConnectStatus && _locStatus) {
      _subscription = flutterReactiveBle.scanForDevices(
        withServices: [
          Uuid.parse(_serviceUuid),
          Uuid.parse(_anotherUuid),
        ],
        scanMode: ScanMode.lowLatency,
      ).listen(
        (device) {
          if (device.id == "F4:CE:7B:D9:35:0B") {
            _devicesData.add(
              device.manufacturerData,
            );
            setState(() {});
            _logTreelDeviceData(device);
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).clearMaterialBanners();
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Column(
            children: const [
              Text('Please enable Bluetooth!'),
            ],
          ),
          actions: [
            OutlinedButton.icon(
              onPressed: () => _startScan(context),
              icon: const Icon(Icons.check),
              label: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    flutterReactiveBle.initialize();
    super.initState();
  }

  @override
  void dispose() {
    flutterReactiveBle.deinitialize();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () => _startScan(context),
                icon: const Icon(Icons.search),
                label: const Text('Scan'),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  _subscription.pause();
                  log('paused', name: 'BLE Status');
                },
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  _subscription.resume();
                  log('resumed', name: 'BLE Status');
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Resume'),
              ),
            ],
          ),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: _devicesData.map((_e) => Text(_e.toString())).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _logTreelDeviceData(DiscoveredDevice device) {
    TreelBeacon? _beacon = ConversionUtils.getTreelBeacon(
      device.manufacturerData,
    );

    if(_beacon == null) return; 

    if (_beacon.getMacID() == _serviceUuid) {
      String _macAddress = device.id;
      _beacon.setMacID(_macAddress);
    }

    int _pressure = ConversionUtils.getDecimal(
      ConversionUtils.decimalToByteArray(
        _beacon.getMinor(),
      ).first,
    );

    log(
      "Beacon Mac ID: ${_beacon.getMacID()} and pressure: ${_pressure.toString()}",
      name: 'Beacon pressure id',
    );
  }
}
