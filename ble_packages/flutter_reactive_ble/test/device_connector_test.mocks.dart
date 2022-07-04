// Mocks generated by Mockito 5.0.14 from annotations
// in flutter_reactive_ble/test/device_connector_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as _i3;
import 'package:flutter_reactive_ble/src/device_scanner.dart' as _i5;
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart'
    as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:reactive_ble_platform_interface/src/models.dart' as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeResult_0<Value, Failure> extends _i1.Fake
    implements _i2.Result<Value, Failure> {}

class _FakeWriteCharacteristicInfo_1 extends _i1.Fake
    implements _i2.WriteCharacteristicInfo {}

class _FakeConnectionPriorityInfo_2 extends _i1.Fake
    implements _i2.ConnectionPriorityInfo {}

class _FakeDateTime_3 extends _i1.Fake implements DateTime {}

/// A class which mocks [ReactiveBlePlatform].
///
/// See the documentation for Mockito's code generation for more information.
class MockReactiveBlePlatform extends _i1.Mock
    implements _i3.ReactiveBlePlatform {
  MockReactiveBlePlatform() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i2.ScanResult> get scanStream =>
      (super.noSuchMethod(Invocation.getter(#scanStream),
              returnValue: Stream<_i2.ScanResult>.empty())
          as _i4.Stream<_i2.ScanResult>);
  @override
  _i4.Stream<_i2.BleStatus> get bleStatusStream => (super.noSuchMethod(
      Invocation.getter(#bleStatusStream),
      returnValue: Stream<_i2.BleStatus>.empty()) as _i4.Stream<_i2.BleStatus>);
  @override
  _i4.Stream<_i2.ConnectionStateUpdate> get connectionUpdateStream =>
      (super.noSuchMethod(Invocation.getter(#connectionUpdateStream),
              returnValue: Stream<_i2.ConnectionStateUpdate>.empty())
          as _i4.Stream<_i2.ConnectionStateUpdate>);
  @override
  _i4.Stream<_i2.CharacteristicValue> get charValueUpdateStream =>
      (super.noSuchMethod(Invocation.getter(#charValueUpdateStream),
              returnValue: Stream<_i2.CharacteristicValue>.empty())
          as _i4.Stream<_i2.CharacteristicValue>);
  @override
  _i4.Future<void> initialize() =>
      (super.noSuchMethod(Invocation.method(#initialize, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> deinitialize() =>
      (super.noSuchMethod(Invocation.method(#deinitialize, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Stream<void> scanForDevices(
          {List<_i2.Uuid>? withServices,
          _i2.ScanMode? scanMode,
          bool? requireLocationServicesEnabled}) =>
      (super.noSuchMethod(
          Invocation.method(#scanForDevices, [], {
            #withServices: withServices,
            #scanMode: scanMode,
            #requireLocationServicesEnabled: requireLocationServicesEnabled
          }),
          returnValue: Stream<void>.empty()) as _i4.Stream<void>);
  @override
  _i4.Future<_i2.Result<_i2.Unit, _i2.GenericFailure<_i2.ClearGattCacheError>?>>
      clearGattCache(String? deviceId) => (super.noSuchMethod(
              Invocation.method(#clearGattCache, [deviceId]),
              returnValue:
                  Future<_i2.Result<_i2.Unit, _i2.GenericFailure<_i2.ClearGattCacheError>?>>.value(
                      _FakeResult_0<_i2.Unit, _i2.GenericFailure<_i2.ClearGattCacheError>?>()))
          as _i4.Future<
              _i2.Result<_i2.Unit, _i2.GenericFailure<_i2.ClearGattCacheError>?>>);
  @override
  _i4.Stream<void> connectToDevice(
          String? id,
          Map<_i2.Uuid, List<_i2.Uuid>>? servicesWithCharacteristicsToDiscover,
          Duration? connectionTimeout) =>
      (super.noSuchMethod(
          Invocation.method(#connectToDevice,
              [id, servicesWithCharacteristicsToDiscover, connectionTimeout]),
          returnValue: Stream<void>.empty()) as _i4.Stream<void>);
  @override
  _i4.Future<void> disconnectDevice(String? deviceId) =>
      (super.noSuchMethod(Invocation.method(#disconnectDevice, [deviceId]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<List<_i2.DiscoveredService>> discoverServices(String? deviceId) =>
      (super.noSuchMethod(Invocation.method(#discoverServices, [deviceId]),
              returnValue: Future<List<_i2.DiscoveredService>>.value(
                  <_i2.DiscoveredService>[]))
          as _i4.Future<List<_i2.DiscoveredService>>);
  @override
  _i4.Stream<void> readCharacteristic(
          _i2.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
          Invocation.method(#readCharacteristic, [characteristic]),
          returnValue: Stream<void>.empty()) as _i4.Stream<void>);
  @override
  _i4.Future<_i2.WriteCharacteristicInfo> writeCharacteristicWithResponse(
          _i2.QualifiedCharacteristic? characteristic, List<int>? value) =>
      (super.noSuchMethod(
              Invocation.method(
                  #writeCharacteristicWithResponse, [characteristic, value]),
              returnValue: Future<_i2.WriteCharacteristicInfo>.value(
                  _FakeWriteCharacteristicInfo_1()))
          as _i4.Future<_i2.WriteCharacteristicInfo>);
  @override
  _i4.Future<_i2.WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
          _i2.QualifiedCharacteristic? characteristic, List<int>? value) =>
      (super.noSuchMethod(
              Invocation.method(
                  #writeCharacteristicWithoutResponse, [characteristic, value]),
              returnValue: Future<_i2.WriteCharacteristicInfo>.value(
                  _FakeWriteCharacteristicInfo_1()))
          as _i4.Future<_i2.WriteCharacteristicInfo>);
  @override
  _i4.Stream<void> subscribeToNotifications(
          _i2.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
          Invocation.method(#subscribeToNotifications, [characteristic]),
          returnValue: Stream<void>.empty()) as _i4.Stream<void>);
  @override
  _i4.Future<void> stopSubscribingToNotifications(
          _i2.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
          Invocation.method(#stopSubscribingToNotifications, [characteristic]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<int> requestMtuSize(String? deviceId, int? mtu) =>
      (super.noSuchMethod(Invocation.method(#requestMtuSize, [deviceId, mtu]),
          returnValue: Future<int>.value(0)) as _i4.Future<int>);
  @override
  _i4.Future<_i2.ConnectionPriorityInfo> requestConnectionPriority(
          String? deviceId, _i2.ConnectionPriority? priority) =>
      (super.noSuchMethod(
          Invocation.method(#requestConnectionPriority, [deviceId, priority]),
          returnValue: Future<_i2.ConnectionPriorityInfo>.value(
              _FakeConnectionPriorityInfo_2())) as _i4
          .Future<_i2.ConnectionPriorityInfo>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [DeviceScanner].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceScanner extends _i1.Mock implements _i5.DeviceScanner {
  MockDeviceScanner() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i2.DiscoveredDevice> scanForDevices(
          {List<_i2.Uuid>? withServices,
          _i2.ScanMode? scanMode = _i2.ScanMode.balanced,
          bool? requireLocationServicesEnabled = true}) =>
      (super.noSuchMethod(
              Invocation.method(#scanForDevices, [], {
                #withServices: withServices,
                #scanMode: scanMode,
                #requireLocationServicesEnabled: requireLocationServicesEnabled
              }),
              returnValue: Stream<_i2.DiscoveredDevice>.empty())
          as _i4.Stream<_i2.DiscoveredDevice>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [DiscoveredDevicesRegistry].
///
/// See the documentation for Mockito's code generation for more information.
class MockDiscoveredDevicesRegistry extends _i1.Mock
    implements _i6.DiscoveredDevicesRegistry {
  MockDiscoveredDevicesRegistry() {
    _i1.throwOnMissingStub(this);
  }

  @override
  DateTime Function() get getTimestamp =>
      (super.noSuchMethod(Invocation.getter(#getTimestamp),
          returnValue: () => _FakeDateTime_3()) as DateTime Function());
  @override
  void add(String? deviceId) =>
      super.noSuchMethod(Invocation.method(#add, [deviceId]),
          returnValueForMissingStub: null);
  @override
  void remove(String? deviceId) =>
      super.noSuchMethod(Invocation.method(#remove, [deviceId]),
          returnValueForMissingStub: null);
  @override
  bool isEmpty() =>
      (super.noSuchMethod(Invocation.method(#isEmpty, []), returnValue: false)
          as bool);
  @override
  bool deviceIsDiscoveredRecently(
          {String? deviceId, Duration? cacheValidity}) =>
      (super.noSuchMethod(
          Invocation.method(#deviceIsDiscoveredRecently, [],
              {#deviceId: deviceId, #cacheValidity: cacheValidity}),
          returnValue: false) as bool);
  @override
  String toString() => super.toString();
}
