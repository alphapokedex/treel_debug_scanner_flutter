import 'dart:developer';
import 'dart:typed_data';

import 'package:convert/convert.dart' show hex;

import 'treel_beacon.dart';

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
      name: 'Treel beacon parsed data:>> ',
    );
    return TreelBeacon(uuid, minor);
  }

  static int getDecimal(value) {
    return value & -1;
  }

  static List<int> decimalToByteArray(int value) {
    String hexString = "0x" + value.toRadixString(16);
    if (hexString.length % 2 != 0) {
      hexString = "0" + hexString;
    }
    return hex.decode(hexString);
  }
}
