import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/db/get_registers.dart';
import 'package:relogio_ponto/models/register.dart';
import 'package:intl/intl.dart';
import '../drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  DataBase db = DataBase();

  RegisterProvider registerInstance = RegisterProvider();

  String tipoRegistro = 'Entrada';

  int paginaAtual = 1;
  late PageController pc;

  List<String> registros = [];
  List<String> registrosEntrada = [];
  List<String> registrosSaida = [];

  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
                        margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (const Text(
                              '  Saldo Mes  \n   00:19:20 \n\n\n',
                              style: TextStyle(
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            )),
                            (const Text(
                              'Intervalo 00:50:25',
                              style: TextStyle(
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            )),
                            LinearPercentIndicator(
                              lineHeight: 13,
                              percent: 0.80,
                              progressColor: Colors.green,
                              backgroundColor: Colors.green.shade100,
                            ),
                          ],
                        ),
                        //color: Colors.black12,    //must be removed
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white, //add it here
                        ),

                        margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 150,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularPercentIndicator(
                              radius: 130,
                              lineWidth: 10,
                              percent: 0.8,
                              progressColor: Colors.red,
                              backgroundColor: Colors.red.shade100,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text('Saldo dia \n   06:41'),
                            )
                          ],
                        ),
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
                future: db.getCheck(user.uid.toString()),
                builder: ((context, snapshot) {
                  return ListView.builder(
                    itemCount: Provider.of<RegisterProvider>(context)
                        .registerGet
                        .length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(Provider.of<RegisterProvider>(context)
                            .registerGet[index]
                            .horario),
                        //title: GetRegistersIn(registers: registros[index]),
                        //Provider.of<MyObjectProvider>(context);
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
          db.getLastCheck(user.uid.toString());
          db.chekIn(1, user.uid.toString(), user.email.toString(), 'Entrada');
        },
        icon: Icon(Icons.app_registration),
        label: const Text(
          'REGISTRAR',
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
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

class DataBase {
  Future<dynamic> chekIn(
      int id, String userId, String email, String tipo) async {
    String sDateTimeNow =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await FirebaseFirestore.instance.collection('registros').add({
      'id': id,
      'horario': sDateTimeNow,
      'id_user': userId,
      'e_mail': email,
      'tipo': tipo
    });
  }

  Future<String> getLastCheck(String userId) async {
    List<String> LastCheck = [];
    String tipoRegistro = '';

    await FirebaseFirestore.instance
        .collection('registros')
        .where('id_user', isEqualTo: userId)
        .orderBy('horario', descending: true)
        .limit(1)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              LastCheck.add(element.reference.id);

              Map<String, dynamic> data =
                  element.data() as Map<String, dynamic>;
              DateTime PrimeiroRegistro = DateTime.parse(data['horario']);
              tipoRegistro = (data['tipo'] == 'Entrada') ? 'Saida' : 'Entrada';
            },
          ),
        );

    return tipoRegistro; // Add the return statement here
  }

  Future<List<String>> getCheck(String userId) async {
    List<String> registros = [];
    List<String> registrosEntrada = [];
    List<String> registrosSaida = [];
    DateTime now = DateTime.now();

    RegisterProvider().resetRegister();

    await FirebaseFirestore.instance
        .collection('registros')
        .where('id_user', isEqualTo: userId)
        .orderBy('horario', descending: true)
        .limit(4)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach((element) {
            registros.add(element.reference.id);
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;

            String tipo = data['tipo'];
            String email = data['e_mail'];
            String userId = data['id_user'];
            String horario = data['horario'];

            Register regs = new Register(
                horario: horario, userId: userId, email: email, tipo: tipo);

            //regTemp(horario: horario, userId: userId, email: email, tipo: tipo);

            RegisterProvider().updateRegister(regs);
          }),
        );
    return registros;
  }
}
