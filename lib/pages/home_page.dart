import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relogio_ponto/read_date/get_registers.dart';

import '../drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final ultimaMarcacao = 'Éntrada';

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  List<String> registros = [];

  Future getLasCheck() async {
    await FirebaseFirestore.instance.collection('registros').get().then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              print(element.reference);
              registros.add(element.reference.id);
            },
          ),
        );
  }

  Future getDateNow() async {
    var dataHoraAtual = DateTime.now().year.toString();
    if (DateTime.now().month.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().month.toString();

    if (DateTime.now().day.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().day.toString();
    return dataHoraAtual;
  }

  Future chekIn() async {
    var dataHoraAtual = DateTime.now().year.toString();
    if (DateTime.now().month.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().month.toString();

    if (DateTime.now().day.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().day.toString();

    await FirebaseFirestore.instance.collection('registros').add(
        {'horario': dataHoraAtual, 'id_user': '123456', 'tipo': 'entrada'});
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
                  onPressed: chekIn,
                  child: const Icon(Icons.punch_clock),
                  backgroundColor: Colors.green,
                ),
                const Text('   Entrada'),
              ],
            ),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  onPressed: chekOut,
                  child: const Icon(Icons.punch_clock_outlined),
                  backgroundColor: Colors.red,
                ),
                const Text('     Saida'),
              ],
            ), */
            //Row(

            // mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            //  Text('Ultimo registro: ' + DateTime.now().toString()),
            //  ],
            //),
            Expanded(
              child: FutureBuilder(
                future: getLasCheck(),
                builder: ((context, snapshot) {
                  return ListView.builder(
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: GetRegisters(registers: registros[index]),
                      );
                    },
                  );
                }),
              ),
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
