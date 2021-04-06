import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'src/serial/serial.dart'
    if (dart.library.io) 'src/serial/serial_main.dart'
    if (dart.library.html) 'src/serial/serial_web.dart';

Future<void> main() async => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  List<dynamic> list = ['Press REFRESH Button'];
  List<String> versions = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSlab demo',
      home: Scaffold(
        appBar: AppBar(title: Text('PSlab')),
        body: Center(child: Text(list.toString() + '\n\n' + versions.toString())),
        persistentFooterButtons: [
          TextButton(
            child: Text('REFRESH'),
            onPressed: () async {

              setState((){list=[]; versions=[];});

              //               V5      V6
              // _USB_VID = [0x04D8, 0x10C4]
              // _USB_PID = [0x00DF, 0xEA60]
              var _list = await Serial.listDevicesWithId([[0x04D8, 0x00DF], [0x10C4, 0xEA60]]);

              _list.asMap().forEach((i, device) async {
                try{
                  var port = Serial(device);
                  await port.onReady;

                  if (! await port.open()) {
                    throw Exception("Failed to open");
                  }

                  versions.add('');
                  StreamSubscription subscription;
                  subscription = port.readerStream.listen((event) {
                    setState(() {
                      versions[i] += String.fromCharCodes(event);
                    });
                  }, cancelOnError: true);

                  await port.write(Uint8List.fromList('\x0b\x05'.codeUnits));

                  Future.delayed(Duration(seconds:2), () async { // timeout
                    await subscription.cancel();
                    await port.close();
                  });
                } catch (e, t) {
                  setState(() {
                    versions.add(e.toString());
                    versions.add(t.toString());
                  });
                }
              });

              setState(() {list = _list;});
            }
          )
        ]
      )
    );
  }
}
