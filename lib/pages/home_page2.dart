import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relogio_ponto/read_date/get_registers.dart';
import 'package:intl/intl.dart';

import '../drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  String tipoRegistro = 'Entrada';

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  String getFormattedDateTimeNow() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(now);
    return formatted;
  }

  int paginaAtual = 1;
  late PageController pc;

  List<String> registros = [];
  List<String> LastCheck = [];

  Future getCheck() async {
    await FirebaseFirestore.instance
        .collection('registros')
        .where('id_user', isEqualTo: user.uid)
        .orderBy('horario', descending: true)
        .limit(1)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              print(element.reference);
              registros.add(element.reference.id);
            },
          ),
        );
  }

  Future getLastCheck() async {
    await FirebaseFirestore.instance
        .collection('registros')
        .where('id_user', isEqualTo: user.uid)
        .orderBy('horario', descending: true)
        .limit(1)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              print(element.reference);
              LastCheck.add(element.reference.id);
              Map<String, dynamic> data =
                  element.data() as Map<String, dynamic>;
              print('${data['tipo']}');
              String temp = data['tipo'];
              if (data['tipo'] == 'Entrada') {
                tipoRegistro = 'Saida';
              } else {
                tipoRegistro = 'Entrada';
              }
            },
          ),
        );
  }

  Future<dynamic> chekIn() async {
    String sDateTimeNow = getFormattedDateTimeNow();
    await FirebaseFirestore.instance.collection('registros').add({
      'id': 1,
      'horario': sDateTimeNow,
      'id_user': user.uid,
      'e_mail': user.email,
      'tipo': tipoRegistro
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saldo dia',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Divider(height: 90, color: Colors.black54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.lock_clock, color: Colors.red),
                    const Text(
                      'Saldo dia',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      '4:41',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.timer, color: Colors.red),
                    const Text(
                      'Saldo semana',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      '4:41',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 90, color: Colors.black54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.lock_clock, color: Colors.red),
                    const Text(
                      'Saldo dia',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      '4:41',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.timer, color: Colors.red),
                    const Text(
                      'Saldo mes',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      '4:41',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 90, color: Colors.black54),
            const Text(
              'Historico',
              style: TextStyle(
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const Divider(color: Colors.black54),
            Expanded(
              child: FutureBuilder(
                future: getCheck(),
                builder: ((context, snapshot) {
                  return ListView.builder(
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: FlutterLogo(),
                        title: GetRegisters(registers: registros[index]),
                        trailing: Icon(Icons.more),
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
          getLastCheck();
          chekIn();
        },
        icon: Icon(Icons.app_registration),
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
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
