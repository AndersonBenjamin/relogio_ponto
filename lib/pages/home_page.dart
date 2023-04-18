import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relogio_ponto/pages/auth_page.dart';
import 'package:relogio_ponto/read_date/get_registers.dart';

import '../drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  var dataHoraAtual = '';

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  int paginaAtual = 1;
  late PageController pc;

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

  Future<dynamic> chekIn() async {
    var dataHoraAtual = DateTime.now().year.toString();

    if (DateTime.now().month.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().month.toString();

    if (DateTime.now().day.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().day.toString();

    dataHoraAtual += ' ';
    if (DateTime.now().hour.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().hour.toString();
    dataHoraAtual += ':';
    if (DateTime.now().minute.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().minute.toString();
    dataHoraAtual += ':';
    if (DateTime.now().second.toString().length == 1) {
      dataHoraAtual += '0';
    }
    dataHoraAtual += DateTime.now().second.toString();

    await FirebaseFirestore.instance.collection('registros').add({
      'horario': dataHoraAtual,
      'id_user': user.uid,
      'e-mail': user.email,
      'tipo': 'entrada'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey, actions: [
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
            const Text(
              'Historico',
              style: TextStyle(
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const Divider(
              color: Colors.black54,
            ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          chekIn();
        },
        icon: Icon(Icons.history),
        label: Text(
          'REGISTRAR',
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Historico'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
        backgroundColor: Colors.grey,
      ),
    );
  }
}
