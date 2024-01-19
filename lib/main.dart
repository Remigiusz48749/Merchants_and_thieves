import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
//import 'dart:typed_data';

int seed = 0;
// ignore: non_constant_identifier_names
int NC = 3; //liczba zmian
// ignore: non_constant_identifier_names
int TC = 20; //time do zmiany

// ignore: non_constant_identifier_names
String Team = "A";
// ignore: non_constant_identifier_names
String Klasa = "Merchant";

void main() {
  runApp(const MyApp());
}

int generateSeed(int leng) {
  int s = 0;
  int ii = 1;
  for (int i = 0; i < leng; i++) {
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
  String ncHint = '2';
  String tcHint = '20 min';

  @override
  void initState() {
    super.initState();
    setState(() {
      seed = generateSeed(NC);
    });
  }

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
                setState(() {
                  //delet only "setState" when bluetooth is ready
                  seed = generateSeed(NC);
                });
              },
              child: const Text('Generate seed'),
            ),
            Text(seed.toString()), //delet this when bluetooth is ready
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Number of changes ',
                ),
                DropdownButton<int>(
                  value: (NC - 1), // Set the current value of NC
                  items: [1, 2, 3, 4, 5, 6].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        ncHint = '$value';
                        NC = value + 1;
                        seed = generateSeed(NC);
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
            JoinScreenBody(i: 0, title: widget.title),
          ],
        ),
      ),
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
      body: JoinScreenBody(i: 1, title: widget.title),
    );
  }
}

class JoinScreenBody extends StatefulWidget {
  final int i;
  final String title;
  JoinScreenBody({required this.i, required this.title});

  @override
  _JoinScreenBody createState() => _JoinScreenBody(i: i, title: title);
}

class _JoinScreenBody extends State<JoinScreenBody> {
  //BluetoothDevice? targetDevice;
  //BluetoothCharacteristic? targetCharacteristic;

  int i;
  String title;
  _JoinScreenBody({required this.i, required this.title});
  String req = "";

  String ncHint = '2'; //delet this when bluetooth is ready
  String tcHint = '20 min'; //delet this when bluetooth is ready

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ..._InstedOffBluetooth(context), //delet this when bluetooth is ready
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (seed != 0) {
                //delet this if when bluetooth is ready
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlueScreen(
                            i: i,
                            title: title,
                          )),
                );
              } else {
                setState(() {
                  req = "No seed/or other data, please go back and set it";
                });
              }
            },
            child: Text("Go!"),
          ),
          Text(req),
        ],
      ),
    );
  }

  //delet this function when bluetooth is ready
  List<Widget> _InstedOffBluetooth(BuildContext context) {
    if (i == 1) {
      return [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Set the seed ',
            ),
            Container(
              width: 100,
              height: 32,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      seed = int.parse(value);
                    });
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Number of changes ',
            ),
            DropdownButton<int>(
              value: (NC - 1), // Set the current value of NC
              items: [1, 2, 3, 4, 5, 6].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
              onChanged: (int? value) {
                if (value != null) {
                  setState(() {
                    ncHint = '$value';
                    NC = value + 1;
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
      ];
    } else {
      return [];
    }
  }
}

class BlueScreen extends StatefulWidget {
  BlueScreen({required this.i, required this.title});
  final int i;
  final String title;

  @override
  State<BlueScreen> createState() => _BlueScreen();
}

class _BlueScreen extends State<BlueScreen> {
  String BluHint = '';

  @override
  void initState() {
    super.initState();
    if (widget.i == 1) {
      BluHint = "You came her from the JoinScreen!";
    } else {
      BluHint = "You came her from the HostScreen!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(BluHint),
            const Text("Here supoest to be the bluetooth screen"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              child: const Text('Start game'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreen();
}

class _GameScreen extends State<GameScreen> {
  late Timer _timer;
  int ts = 0;
  String tsT = "00";
  int interval = TC;
  int tm = TC * NC;

  int sell1 = 0;
  int sell2 = 0;
  int sell3 = 0;

  int score = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void seedcuter() {
    try {
      int y = (pow(10, (NC - 1))).toInt();
      int x = ((seed / y).floor());
      setState(() {
        seed = seed - (x * y);
        NC--;
      });
      ChangeSell(x);
    } catch (e) {
      int x = 7;
      ChangeSell(x);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (ts > 0) {
          ts--;
          if (ts < 10) {
            tsT = "0$ts";
          } else {
            tsT = "$ts";
          }
        } else {
          ts = 59;
          if (tm == 0) {
            timer.cancel();
          } else {
            if (tm % interval == 0) {
              seedcuter();
            }
            tm--;
            tsT = "$ts";
          }
        }
      });
    });
  }

  void ChangeSell(int x) {
    int n1 = 5;
    int n2 = 3;
    int n3 = 2;
    switch (x) {
      case 1:
        setState(() {
          sell1 = n1;
          sell2 = n2;
          sell3 = n3;
        });
        break;
      case 2:
        setState(() {
          sell1 = n1;
          sell2 = n3;
          sell3 = n2;
        });
        break;
      case 3:
        setState(() {
          sell1 = n2;
          sell2 = n3;
          sell3 = n1;
        });
        break;
      case 4:
        setState(() {
          sell1 = n3;
          sell2 = n2;
          sell3 = n1;
        });
        break;
      case 5:
        setState(() {
          sell1 = n2;
          sell2 = n1;
          sell3 = n3;
        });
        break;
      case 6:
        setState(() {
          sell1 = n3;
          sell2 = n1;
          sell3 = n2;
        });
        break;
      default:
        setState(() {
          sell1 = 7;
          sell2 = 7;
          sell3 = 7;
        });
        break;
    }
  }

  void ChangeScore(int x) {
    setState(() {
      score = score + x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Team: $Team"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            Text("$tm:$tsT"), //timer
            const SizedBox(height: 16),
            Text("Klasa: $Klasa"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 192, 192, 192),
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("$sell1"),
                      const Text("silver"),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 210, 4, 45),
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("$sell2"),
                      const Text("Silk"),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 225, 162, 93),
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("$sell3"),
                      const Text("spices"),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ChangeScore(-2);
                  },
                  child: const Text("<<"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ChangeScore(-1);
                  },
                  child: const Text("<"),
                ),
                Container(
                  width: 64,
                  height: 64,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("$score"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ChangeScore(1);
                  },
                  child: const Text(">"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ChangeScore(2);
                  },
                  child: const Text(">>"),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
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
      body: Text("Info"),
    );
  }
}
