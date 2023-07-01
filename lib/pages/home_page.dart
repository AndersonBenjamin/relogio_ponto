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
  List<String> registrosEntrada = [];
  List<String> registrosSaida = [];
  List<String> LastCheck = [];

  Future getCheck() async {
    DateTime dt1 = DateTime.parse("2023-06-27 09:00:00");
    DateTime dt2 = DateTime.parse("2023-06-27 09:00:00");

    Duration diff = dt1.difference(dt2);

    print(diff.inDays);
//output (in days): 1198

    print(diff.inHours);
//output (in hours): 28752

    print(diff.inMinutes);
//output (in minutes): 1725170

    print(diff.inSeconds);
//output (in seconds): 103510200
    await FirebaseFirestore.instance
        .collection('registros')
        .where('id_user', isEqualTo: user.uid)
        .orderBy('horario', descending: true)
        .limit(10)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              print(element.reference);
              registros.add(element.reference.id);

              Map<String, dynamic> data =
                  element.data() as Map<String, dynamic>;
              print('${data['tipo']}');
              String temp = data['tipo'];
              if (temp == 'Entrada') {
                registrosSaida.add(element.reference.id);
              } else {
                registrosEntrada.add(element.reference.id);
              }
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

              DateTime PrimeiroRegistro = DateTime.parse(data['horario']);

              tipoRegistro = (data['tipo'] == 'Entrada') ? 'Saida' : 'Entrada';
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
          'Olá Anderson',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
            const Divider(height: 30, color: Colors.black54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white, //add it here
                        ),
                        child: (const Text(
                          '     Saldo dia \n        04:41  \n\n\n      Intervalo      \n        01:00',
                          style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )),
                        margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 150,
                        //color: Colors.black12,    //must be removed
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white, //add it here
                        ),
                        child: (const Text(
                          '  Saldo semana \n        04:41  \n\n\n    Saldo Mes      \n        01:00',
                          style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )),
                        margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 150,
                        //color: Colors.black12,    //must be removed
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 50, color: Colors.black54),
            const Text(
              'Registros: 24/06/2023',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Divider(height: 20, color: Colors.black54),
            const Text(
              '    Entrada         |           Saida        ',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 15,
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
                        title: GetRegistersIn(registers: registros[index]),
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
