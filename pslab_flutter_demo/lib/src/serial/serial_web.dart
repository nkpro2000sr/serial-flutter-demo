import 'dart:typed_data';
// yet to find package
import 'serial.dart' as serialIntf;

class Serial implements serialIntf.Serial {
  Serial(dynamic device); // yet to write implementations.

  dynamic get port {}

  static Future<List<dynamic>> listDevices() async {
    return [];
  }

  static Future<List<dynamic>> listDevicesWithId(List<List<int>> vidPidPairs) async {
    return [];
  }

  Future<bool> open() async {return false;}

  Stream<Uint8List> get readerStream {return Stream.empty();}

  Future<void> write(Uint8List data) async {}

  Future<bool> close() async {return false;}

}
