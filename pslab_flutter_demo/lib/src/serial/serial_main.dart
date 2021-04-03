import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:libserialport/libserialport.dart';
import 'package:usb_serial/usb_serial.dart';
import 'serial.dart' as serialIntf;


class Serial implements serialIntf.Serial {
  UsbPort _usbSerialPort; // For ANDROID & IOS
  SerialPort _libserialportPort; // For MACOS, LINUX & WINDOWS

  Serial(dynamic device) {
    if (Platform.isAndroid || Platform.isIOS) {
      _usbSerialPort = device.create();
    } else {
      _libserialportPort = SerialPort(device);
    }
  }

  dynamic get port {
    if (Platform.isAndroid || Platform.isIOS) {
      return _usbSerialPort;
    } else {
      return _libserialportPort;
    }
  }

  static Future<List<dynamic>> listDevices() async {
    if (Platform.isAndroid || Platform.isIOS) {
      List<dynamic> list = (await UsbSerial.listDevices());
      return list;
    } else {
      List<dynamic> list = SerialPort.availablePorts;
      return list;
    }
  }

  static Future<List<dynamic>> listDevicesWithId(List<List<int>> vidPidPairs) async {
    if (Platform.isAndroid || Platform.isIOS) {
      List<dynamic> list = (await UsbSerial.listDevices());
      return [
        for (var d in list)
          if (vidPidPairs.any((e) => e[0]==d.vid && e[1]==d.pid))
            d
      ];
    } else {
      List<dynamic> list = SerialPort.availablePorts;
      return [
        for (var d in list.map((e) => SerialPort(e)))
          if (vidPidPairs.any((e) {
            try {return e[0]==d.vendorId && e[1]==d.productId;}
            on SerialPortError {return false;}
            }))
              d.name
      ];
    }
  }

  Future<bool> open([int baudrate = 1000000]) async {
    if (Platform.isAndroid || Platform.isIOS) {
      bool rtn = await _usbSerialPort.open();
      _usbSerialPort.setPortParameters(
        baudrate, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE
      );
      return rtn;
    } else {
      bool rtn = _libserialportPort.openReadWrite();
      _libserialportPort.config.baudRate = baudrate;
      return rtn;
    }
  }

  Stream<Uint8List> get readerStream {
    if (Platform.isAndroid || Platform.isIOS) {
      return _usbSerialPort.inputStream;
    } else {
      return SerialPortReader(_libserialportPort).stream;
    }
  }

  Future<void> write(Uint8List data) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await _usbSerialPort.write(data);
    } else {
      _libserialportPort.write(data);
    }
  }

  Future<bool> close() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _usbSerialPort.close();
    } else {
      return _libserialportPort.close();
    }
  }

}
