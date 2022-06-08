import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

class DeviceInfo {
  String? model;
  String? version;
  String? id;
  String? os;
  String? manufacturer;

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      debugPrint('Running on ${androidInfo.model}');
      debugPrint('Version ${androidInfo.version.release}');
      debugPrint('Base OS ${androidInfo.version.baseOS}');
      debugPrint('Manufacturer ${androidInfo.manufacturer}');

      model = androidInfo.model;
      version = androidInfo.version.release;
      id = androidInfo.androidId;
      os = 'Android';
      manufacturer = androidInfo.manufacturer;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      debugPrint('Running on ${iosInfo.model}');
      debugPrint('Version ${iosInfo.systemVersion}');
      debugPrint('OS ${iosInfo.systemName}');

      model = iosInfo.model;
      version = iosInfo.systemVersion;
      id = iosInfo.identifierForVendor;
      os = iosInfo.systemName;
      manufacturer = 'Apple';
    }
  }
}
