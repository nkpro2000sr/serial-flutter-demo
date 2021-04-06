import 'dart:typed_data';

class Serial {
  Future onReady;

  Serial(dynamic device);

  dynamic get port {}

  static Future<List<dynamic>> listDevices() async {
    return [];
  }

  static Future<List<dynamic>> listDevicesWithId(List<List<int>> vidPidPairs) async {
    return [];
  }

  Future<bool> open([int baudrate]) async {return false;}

  Stream<Uint8List> get readerStream {return Stream.empty();}

  Future<void> write(Uint8List data) async {}

  Future<bool> close() async {return false;}

}
