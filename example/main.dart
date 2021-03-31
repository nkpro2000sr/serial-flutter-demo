import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'src/serial/serial.dart'
    if (dart.library.io) 'src/serial/serial_main.dart'
    if (dart.library.html) 'src/serial/serial_web.dart';

Future<void> main() async => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String list = 'Press REFRESH Button';
  StreamSubscription _subscription;
  Serial _port;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'try serial',
      home: Scaffold(
        appBar: AppBar(title: Text("Sample Serial Communicaion")),
        body: Center(child: Text(list)),
        persistentFooterButtons: [
          TextButton(
            child: Text('REFRESH'),
            onPressed: () async {
              var _list = await Serial.listDevices();

              if (_list.length >= 1) {

                await _subscription?.cancel();
                await _port?.close();

                _port = Serial(_list[0]);

                if (! await _port.open()) {
                  throw Exception("Failed to open");
                }

                _subscription = _port.readerStream.listen((event) async {
                    setState(() {
                      list = _list.toString() + '\n\n${String.fromCharCodes(event)}';
                    });
                    await _subscription.cancel();
                    await _port.close();
                  }
                );

                await _port.write(Uint8List.fromList('hi'.codeUnits));
              }

              setState(() {list = _list.toString();});
            }
          )
        ]
      )
    );
  }
}
