import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final dataHoraAtual = DateTime.now();
  final ultimaMarcacao = 'Éntrada';

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future getLasCheck() async {
    final lastCheckDb = await FirebaseFirestore.instance
        .collection('registros')
        .where('id_user', isEqualTo: '1234');
  }

  Future chekIn() async {
    await FirebaseFirestore.instance
        .collection('registros')
        .add({'horario': DateTime.now(), 'id_user': '1234', 'tipo': 'entrada'});
  }

  Future chekOut() async {
    await FirebaseFirestore.instance
        .collection('registros')
        .add({'horario': DateTime.now(), 'id_user': '1234', 'tipo': 'saida'});
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton.large(
                  onPressed: getLasCheck,
                  child: const Icon(Icons.punch_clock),
                  backgroundColor: Colors.green,
                ),
                const Text('   Entrada'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              children: [
                Text('Ultimo registro: ' + DateTime.now().toString()),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: chekIn,
        tooltip: 'Increment',
        child: const Icon(Icons.history),
      ),
    );
  }
}
