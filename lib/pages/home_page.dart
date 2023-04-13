import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future chekIn() async {
    await FirebaseFirestore.instance
        .collection('registros')
        .add({'horario': '00:01:00', 'id_user': '1234', 'tipo': 'entrada'});
  }

  Future chekOut() async {
    await FirebaseFirestore.instance
        .collection('registros')
        .add({'horario': '00:01:00', 'id_user': '1234', 'tipo': 'saida'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange, actions: [
        IconButton(
          onPressed: signUserOut,
          icon: Icon(Icons.logout),
        ),
      ]),
      drawer: NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20),
                FloatingActionButton.large(
                  onPressed: chekIn,
                  child: const Icon(Icons.punch_clock),
                  backgroundColor: Colors.green,
                ),
                const Text('   Entrada'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20),
                FloatingActionButton.large(
                  onPressed: chekOut,
                  child: const Icon(Icons.punch_clock_outlined),
                  backgroundColor: Colors.red,
                ),
                const Text('     Saida'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20),
                FloatingActionButton.large(
                  onPressed: chekIn,
                  child: const Icon(Icons.history),
                ),
                const Text('Historico'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: chekIn,
        tooltip: 'Increment',
        child: const Icon(Icons.history),
      ),
    );
  }
}
