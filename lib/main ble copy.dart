import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/*
import '/Widget/Scan_Result_Tile.dart';
import '../utils/extra.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merchants and thieves',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Merchants and thieves'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16), //Add space
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BluethoothScreen(i: 0)),
                );
              },
              child: const Text('Bluethooth step 0'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BluethoothScreen(i: 1)),
                );
              },
              child: const Text('Bluethooth step 1'),
            ),
          ],
        ),
      ),
    );
  }
}

class BluethoothScreen extends StatefulWidget {
  const BluethoothScreen({required this.i});
  final int i;
  @override
  State<BluethoothScreen> createState() => _BluethoothScreen(i: i);
}

class _BluethoothScreen extends State<BluethoothScreen> {
  final int i;
  _BluethoothScreen({required this.i});

  int err = 0;
  String ScanData = '';
  String Error = "";

  int seed = 123321;
  int NC = 2;
  int TC = 32;
  String MacID = "Loading...";

  int dataSeed = 0;
  int dataTC = 0;
  int dataNC = 0;
  String B = '';

  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void check() async {
    if (await FlutterBluePlus.isSupported == false) {
      setState(() {
        B = "Not suported on this device";
      });
      return;
    }

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        scan();
      } else {
        setState(() {
          B = "Turn on Bluetooth";
        });
        return;
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future scan() async {
    _systemDevices = await FlutterBluePlus.systemDevices;
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    if (mounted) {
      setState(() {});
    }

    setState(() {
      err = err + 1;
    });
  }

  void Connect(BluetoothDevice device) async {
    device.connectAndUpdateStream();
    await device.connect();
    setState(() {
      B = B + "Device connected";
    });
    if (i == 0) {
      Write(device);
    } else {
      Read(device);
    }
    await device.disconnect();
  }

  void Write(BluetoothDevice device) async {
    setState(() {
      B = B + "Write started";
    });
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      SendSeed(service);
    });
  }

  void SendSeed(sevice) async {
    List<int> dataToSend = [seed, NC, TC]; // Replace with your integer data
    await sevice.write(dataToSend, allowLongWrite: true);
    setState(() {
      B = B + "Send seed";
    });
  }

  void Read(BluetoothDevice device) async {
    setState(() {
      B = B + "Read started";
    });
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      GetSeed(service);
    });
  }

  void GetSeed(service) async {
    var characteristics = service.characteristics;
    for (BluetoothCharacteristic c in characteristics) {
      if (c.properties.read) {
        ReadCharacteristic(c);
      }
    }
  }

  void ReadCharacteristic(BluetoothCharacteristic c) async {
    List<int> value = await c.read();
    setState(() {
      dataSeed = value[0];
      dataTC = value[1];
      dataNC = value[2];
    });
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => ScanResultTile(
            result: r, // Pass the ScanResult to the ScanResultTile widget
            onTap: () => Connect(r.device),
            i: i,
          ),
        )
        .toList(); // Convert the mapped Iterable to a List
  }

  void sendMessage() {
    /*if (characteristic != null) {
      int value = 101;
      //List<int> bytes = value.toBytes();
      //characteristic!.write(bytes);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Time: " +
            (dataTC * dataNC).toString() +
            " Price change: " +
            dataTC.toString()),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(B),
              Text("Your id:$MacID"),
              ..._buildScanResultTiles(context),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: check,
                child: Text('Connect to Device'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendMessage,
                child: Text('Send Message'),
              ),
              Text("krok:$err " + Error),
            ],
          ),
        ),
      ),
    );
  }
}*/
