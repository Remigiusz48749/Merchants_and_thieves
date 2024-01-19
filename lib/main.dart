import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';

int seed = 0;
int NC = 3; //liczba zmian
int TC = 20; //time do zmiany

String Team = "A";
String Klasa = "Merchant";
void main() {
  runApp(const MyApp());
}

int generateSeed(int leng) {
  int s = 0;
  int ii = 1;
  for (int i = 1; i < leng; i++) {
    s = s + (Random().nextInt(6) + 1) * ii;
    ii = ii * 10;
  }
  return s;
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
                      builder: (context) => HostScreen(title: widget.title)),
                );
              },
              child: const Text('Host game'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JoinScreen(title: widget.title)),
                );
              },
              child: const Text('Join game'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InfoScreen(title: widget.title)),
                );
              },
              child: const Text('Info game'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HostScreen extends StatefulWidget {
  const HostScreen({super.key, required this.title});
  final String title;
  @override
  State<HostScreen> createState() => _HostScreen();
}

class _HostScreen extends State<HostScreen> {
  String ncHint = '3';
  String tcHint = '20 min';
  String sHint = 'Next Step';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16), //Add space
            ElevatedButton(
              onPressed: () {
                seed = generateSeed(6);
              },
              child: const Text('Generate seed'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Number of changes ',
                ),
                DropdownButton<int>(
                  value: NC, // Set the current value of NC
                  items: [1, 2, 3, 4, 5, 6].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        NC = value;
                        ncHint = '$value';
                      });
                    }
                  },
                  hint: Text(ncHint),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Time between price changes ',
                ),
                DropdownButton<int>(
                  value: TC,
                  items: [1, 3, 5, 10, 15, 20, 30].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value min'),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        TC = value;
                        tcHint = '$value min';
                      });
                    }
                  },
                  hint: Text(tcHint),
                ),
              ],
            ),
            JoinScreenBody(),
          ],
        ),
      ),
      //body: JoinScreenBody(),
    );
  }
}

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key, required this.title});
  final String title;
  @override
  State<JoinScreen> createState() => _JoinScreen();
}

class _JoinScreen extends State<JoinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      body: JoinScreenBody(),
    );
  }
}

class JoinScreenBody extends StatefulWidget {
  @override
  _JoinScreenBody createState() => _JoinScreenBody();
}

class _JoinScreenBody extends State<JoinScreenBody> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothState bluetoothState = BluetoothState.unknown;
  String BluHint = "Get seed/Share seed";
  String CHint = 'Next Step';

  @override
  void initState() {
    super.initState();

    // Check Bluetooth state when the widget is initialized
    flutterBlue.state.listen((state) {
      setState(() {
        bluetoothState = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Chosen Team ',
              ),
              DropdownButton<String>(
                value: Team, // Set the current value of NC
                items: ["A", "B"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      Team = value;
                    });
                  }
                },
                hint: Text(Team),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Class chosen ',
              ),
              DropdownButton<String>(
                value: Klasa,
                items: ["Merchant", "Thief", "Knight"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      Klasa = value;
                    });
                  }
                },
                hint: Text(Klasa),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (bluetoothState == BluetoothState.on) {
                //s
              } else {
                setState(() {
                  BluHint = "activ bluetooth";
                });
              }
            },
            child: Text(BluHint),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (seed != 0) {
                //go to gameScreen
              } else {
                setState(() {
                  CHint = "No seed";
                });
              }
            },
            child: Text(CHint),
          ),
        ],
      ),
    );
  }
}

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key, required this.title});
  final String title;
  @override
  State<InfoScreen> createState() => _InfoScreen();
}

class _InfoScreen extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      //her put more
    );
  }
}
