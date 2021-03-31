import 'dart:typed_data';

class Serial {
  Serial(dynamic device);

  static Future<List<dynamic>> listDevices() async {
    return [];
  }

  Future<bool> open() async {return false;}

  Stream<Uint8List> get readerStream {return Stream.empty();}

  Future<void> write(Uint8List data) async {}

  Future<bool> close() async {return false;}

}
