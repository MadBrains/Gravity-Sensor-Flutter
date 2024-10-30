import 'dart:js_interop';

/// GravitySensor API
/// https://developer.mozilla.org/en-US/docs/Web/API/GravitySensor
@JS('GravitySensor')
extension type GravitySensorJS._(JSObject _) implements JSObject {
  external factory GravitySensorJS();

  external double get x;
  external double get y;
  external double get z;

  external set onreading(JSFunction callback);

  external void start();
}
