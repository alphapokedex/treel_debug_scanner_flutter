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

  final Map<String, dynamic> _devicesData = {};

  Future<void> _startScan(BuildContext context) async {
    PermissionStatus _btStatus = await Permission.bluetooth.request();
    PermissionStatus _locStatus = await Permission.location.request();
    if (_btStatus.isGranted && _locStatus.isGranted) {
      _subscription = flutterReactiveBle.scanForDevices(
        withServices: [
          /* Uuid.parse(_serviceUuid), */ /* Uuid.parse(_anotherUuid), */
        ],
        scanMode: ScanMode.lowLatency,
      ).listen(
        (device) {
          if (device.id == "F4:CE:7B:D9:35:0B") {
            _devicesData.putIfAbsent(
              device.id,
              () => {
                'id': device.id,
                'rssi': device.rssi,
                'manu_data': device.manufacturerData,
                'services_data': device.serviceData,
                'services_uuid': device.serviceUuids,
              },
            );
            setState(() {});
            log('${device.serviceData}', name: 'device service data: >>');
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

  void _logTreelDeviceData(DiscoveredDevice device) {
    TreelBeacon? _beacon = ConversionUtils.getTreelBeacon(
      device.serviceData.values.first,
    )!;

    /// null check for _beacon
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
      "Beacon Mac ID: " +
          _beacon.getMacID() +
          " and minor " +
          _pressure.toString(),
      name: 'Beacon pressure id',
    );

    String _macAddress2 = device.id;

    /*TreelBeacon beacon = ConversionUtils.getTreelBeacon(scanResult.getScanRecord().getBytes());
        if (beacon != null) {
            if (!Intrinsics.areEqual((Object) beacon.getMacID(), (Object) BluetoothUUID.INSTANCE.getTREEL_IBEACON_SERVICE_UUID().toString())) {
                String macAddress = scanResult.getBleDevice().getMacAddress();
                Intrinsics.checkNotNullExpressionValue(macAddress, "scanResult.bleDevice.macAddress");
                beacon.setMacID(macAddress);
            }
            int pressure = ConversionUtils.getDecimal(ConversionUtils.decimalToByteArray(beacon.getMinor())[1]);
            Timber.m30d("Beacon Mac ID: " + beacon.getMacID() + " and minor " + pressure, new Object[0]);
            DeviceDataParser deviceDataParser = DeviceDataParser.INSTANCE;
            String macAddress2 = scanResult.getBleDevice().getMacAddress();
            Intrinsics.checkNotNullExpressionValue(macAddress2, "scanResult.bleDevice.macAddress");
            String[] receivedData = deviceDataParser.parseTreelBeaconData(macAddress2, String.valueOf(pressure));
            int i = this.logsCounter + 1;
            this.logsCounter = i;
            receivedData[0] = String.valueOf(i);
            LinkedHashMap<String, String[]> linkedHashMap = this.devicesData;
            if (linkedHashMap != null) {
                String[] strArr = (String[]) linkedHashMap.put(scanResult.getBleDevice().getMacAddress(), receivedData);
            }
            MutableLiveData<LinkedHashMap<String, String[]>> mutableLiveData = this.devices;
            if (mutableLiveData != null) {
                mutableLiveData.setValue(this.devicesData);
            }
            try {
                if (this.logsWriter == null) {
                    writeHeaders();
                }
                writeLog(this.logsWriter, receivedData);
            } catch (Exception e) {
                Timber.m34e(e);
            }
        } else {
            BluetoothUUID bluetoothUUID = BluetoothUUID.INSTANCE;
            ScanRecord scanRecord = scanResult.getScanRecord();
            Intrinsics.checkNotNullExpressionValue(scanRecord, "scanResult.scanRecord");
            if (bluetoothUUID.isTreelBleDevice(scanRecord)) {
                Timber.m30d(Intrinsics.stringPlus("Device Detected Treel: ", scanResult.getBleDevice().getMacAddress()), new Object[0]);
                String[] receivedData2 = getParsedData(scanResult);
                int i2 = this.logsCounter + 1;
                this.logsCounter = i2;
                receivedData2[0] = String.valueOf(i2);
                LinkedHashMap<String, String[]> linkedHashMap2 = this.devicesData;
                if (linkedHashMap2 != null) {
                    String[] strArr2 = (String[]) linkedHashMap2.put(scanResult.getBleDevice().getMacAddress(), receivedData2);
                }
                MutableLiveData<LinkedHashMap<String, String[]>> mutableLiveData2 = this.devices;
                if (mutableLiveData2 != null) {
                    mutableLiveData2.setValue(this.devicesData);
                }
                try {
                    if (this.logsWriter == null) {
                        writeHeaders();
                    }
                    writeLog(this.logsWriter, receivedData2);
                } catch (Exception e2) {
                    Timber.m34e(e2);
                }
            } else {
                BluetoothUUID bluetoothUUID2 = BluetoothUUID.INSTANCE;
                ScanRecord scanRecord2 = scanResult.getScanRecord();
                Intrinsics.checkNotNullExpressionValue(scanRecord2, "scanResult.scanRecord");
                if (bluetoothUUID2.isCradlerDevice(scanRecord2) && this.deviceType != 1) {
                    Timber.m30d(Intrinsics.stringPlus("Device Detected Cradler: ", scanResult.getBleDevice().getMacAddress()), new Object[0]);
                    String[] receivedData3 = getParsedData(scanResult);
                    int i3 = this.logsCounter + 1;
                    this.logsCounter = i3;
                    receivedData3[0] = String.valueOf(i3);
                    LinkedHashMap<String, String[]> linkedHashMap3 = this.devicesData;
                    if (linkedHashMap3 != null) {
                        String[] strArr3 = (String[]) linkedHashMap3.put(scanResult.getBleDevice().getMacAddress(), receivedData3);
                    }
                    MutableLiveData<LinkedHashMap<String, String[]>> mutableLiveData3 = this.devices;
                    if (mutableLiveData3 != null) {
                        mutableLiveData3.setValue(this.devicesData);
                    }
                    try {
                        if (this.logsWriter == null) {
                            writeHeaders();
                        }
                        writeLog(this.logsWriter, receivedData3);
                    } catch (Exception e3) {
                        Timber.m34e(e3);
                    }
                }
            }
        }*/
  }
}
