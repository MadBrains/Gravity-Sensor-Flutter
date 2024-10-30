import 'dart:async';
import 'dart:html';
import 'dart:js_interop';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:gravity_sensor/gravity_sensor.dart';

import '../gravity_sensor_platform_interface.dart';
import 'gravity_sensor_web_interop.dart';

/// The sensors plugin.
class GravitySensorWeb extends GravitySensorPlatform {
  GravitySensorWeb() {
    _init();
  }

  /// Factory method that _initializes the Sensors plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    GravitySensorPlatform.instance = GravitySensorWeb();
  }

  final StreamController<GravityEvent> _streamController = StreamController();

  Future<void> _init() async {
    final Permissions? permissions = window.navigator.permissions;
    if (permissions == null) {
      throw StateError("Permissions API is not available in the current environment.");
    }

    final PermissionStatus status = await permissions.query({'name': 'accelerometer'});
    if (status.state != 'granted') {
      throw StateError("\"accelerometer\" permission required by this plugin is not granted.");
    }

    final GravitySensorJS gravitySensor = GravitySensorJS();
    gravitySensor.start();

    gravitySensor.onreading = (JSObject _) {
      _streamController.add(
        GravityEvent(
          gravitySensor.x,
          gravitySensor.y,
          gravitySensor.z,
        ),
      );
    }.toJS;
  }

  @override
  Stream<GravityEvent> get gravityEvents => _streamController.stream;
}
