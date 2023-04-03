import 'dart:async';
import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  late final DatabaseReference _likesRef;
  late StreamSubscription<DatabaseEvent> _likesSubscription;

  @override
  void initState() {
    debugPrint("Entrou no initState");
    super.initState();
    init();
  }

  init() async {
    debugPrint("Entrou no init");
    _likesRef = FirebaseDatabase.instance.ref('likes');
    debugPrint("Vai pegar o _likes");
    debugPrint(_likesRef.toString());
    debugPrint("Pergou o _likes");
    try {
      final likeSnapShot = await _likesRef.get();
      debugPrint("likeSnapShot");
      _counter = likeSnapShot.value as int;
    } catch (err) {
      debugPrint("Entrou no catch");
      debugPrint(err.toString());
    }
    _likesSubscription = _likesRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _counter = (event.snapshot.value ?? 0) as int;
      });
    });
  }

  like() async {
    await _likesRef.set(ServerValue.increment(1));
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void dispose() {
    _likesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: like,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
