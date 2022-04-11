import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

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

  final Map<String, dynamic> _devicesData = {};

  Future<void> _startScan(BuildContext context) async {
    PermissionStatus _btStatus = await Permission.bluetooth.request();
    PermissionStatus _locStatus = await Permission.location.request();
    if (_btStatus.isGranted && _locStatus.isGranted) {
      _subscription = flutterReactiveBle.scanForDevices(
        withServices: [Uuid.parse(_serviceUuid), Uuid.parse(_anotherUuid)],
        scanMode: ScanMode.lowLatency,
      ).listen(
        (device) {
          _devicesData.putIfAbsent(
            device.id,
            () {
              log('${device.serviceData}', name: 'device service data: >>');
              return {
                'id': device.id,
                'rssi': device.rssi,
                'manu_data': device.manufacturerData,
                'services_data': device.serviceData,
                'services_uuid': device.serviceUuids,
              };
            },
          );
          setState(() {});
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
            child: Table(
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text('Device ID'),
                    ),
                    // Text('Rssi'),
                    // Text('Manufacturer Data'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text('Service Data'),
                    ),
                  ],
                ),
                ..._devicesData.values
                    .map(
                      (_e) => TableRow(
                        children: [
                          InkWell(
                            child: Text(_e['id'].toString()),
                            onTap: () {
                              flutterReactiveBle
                                  .connectToAdvertisingDevice(
                                id: _e['id'],
                                withServices: [
                                  Uuid.parse(_serviceUuid),
                                  Uuid.parse(_anotherUuid)
                                ],
                                prescanDuration: const Duration(minutes: 2),
                                connectionTimeout: const Duration(minutes: 1),
                              )
                                  .listen(
                                (connectionState) {
                                  log(
                                    connectionState.connectionState.name,
                                    name: connectionState.deviceId,
                                  );
                                },
                                onError: (dynamic error) {
                                  log(
                                    error.runtimeType.toString(),
                                    name: 'Error on connect: ',
                                  );
                                },
                              );
                            },
                          ),
                          Text(
                            _e.toString(),
                          ),
                        ],
                      ),
                    )
                    .toList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConversionUtils {
  static const String _beaconUuid = 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFE0';

  static String convert(List<int> bytes, int start, int end) {
    var buffer = Uint8List((end - start) * 2);
    var bufferIndex = 0;
    var byteOr = 0;
    for (var i = start; i < end; i++) {
      var byte = bytes[i];
      byteOr |= byte;
      buffer[bufferIndex++] = _codeUnitForDigit((byte & 0xF0) >> 4);
      buffer[bufferIndex++] = _codeUnitForDigit(byte & 0x0F);
    }

    if (byteOr >= 0 && byteOr <= 255) return String.fromCharCodes(buffer);
    for (var i = start; i < end; i++) {
      var byte = bytes[i];
      if (byte >= 0 && byte <= 0xff) continue;
      throw FormatException(
          "Invalid byte ${byte < 0 ? "-" : ""}0x${byte.abs().toRadixString(16)}.",
          bytes,
          i);
    }

    throw 'unreachable';
  }

  static int _codeUnitForDigit(int digit) =>
      digit < 10 ? digit + (0x30) : digit + (0x61) - 10;

  static TreelBeacon? getTreelBeacon(Uint8List scanRecord) {
    int startByte = 2;
    bool patternFound = false;
    while (true) {
      if (startByte <= 5) {
        if ((scanRecord[startByte + 2] & -1) == 2 &&
            (scanRecord[startByte + 3] & -1) == 21) {
          patternFound = true;
          break;
        }
        startByte++;
      } else {
        break;
      }
    }
    if (!patternFound) {
      return null;
    }

    Uint8List uuidBytes = scanRecord.sublist(startByte + 4, startByte + 20);
    String hexString = convert(uuidBytes, 0, uuidBytes.length);
    String uuid = hexString.substring(0, 8) +
        "-" +
        hexString.substring(8, 12) +
        "-" +
        hexString.substring(12, 16) +
        "-" +
        hexString.substring(16, 20) +
        "-" +
        hexString.substring(20, 32);
    if (uuid != _beaconUuid) {
      return null;
    }
    int major = ((scanRecord[startByte + 20] & -1) * 0) +
        (scanRecord[startByte + 21] & -1);
    int minor = ((scanRecord[startByte + 22] & -1) * 0) +
        (scanRecord[startByte + 23] & -1);
    log(
        "UUID: " +
            uuid +
            "\nmajor: " +
            major.toString() +
            "\nminor" +
            minor.toString(),
        name: 'Treel beacon parsed data:>> ');
    return TreelBeacon(uuid, minor);
  }
}
