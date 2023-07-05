import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:relogio_ponto/db/get_registers.dart';
import 'package:relogio_ponto/models/register.dart';
import 'package:intl/intl.dart';
import '../drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  DataBase db = DataBase();

  String tipoRegistro = 'Entrada';
  String formattedDifference = '00:19:20';

  DateTime nowGlobal = DateTime.parse('2023-01-22 09:00:00');

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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (Text(
                              '  Saldo Mes  \n   $formattedDifference \n\n',
                              style: TextStyle(
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            )),
                            (Text(
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
          formatDate();
          formatDate();
          db.getLastCheck(user.uid.toString());
          db.chekIn(1, user.uid.toString(), user.email.toString(), 'Entrada');
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

  String formatDate() {
    DateTime startDateTime = DateTime.parse('2023-01-22 09:00:00');
    DateTime endDateTime = DateTime.parse('2023-01-23 18:21:00');

    Duration difference = endDateTime.difference(startDateTime);
    formattedDifference = formatDuration(difference);

    print('Difference: $formattedDifference');
    return formattedDifference;
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  String getFormattedDateTimeNow() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(now);
    return formatted;
  }

  Future getCheck() async {
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('registros')
        .where('id_user', isEqualTo: user.uid)
        .orderBy('horario', descending: true)
        .limit(4)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              registros.add(element.reference.id);
              Map<String, dynamic> data =
                  element.data() as Map<String, dynamic>;
              String temp = data['tipo'];
              temp == 'Entrada'
                  ? registrosSaida.add(element.reference.id)
                  : registrosEntrada.add(element.reference.id);
            },
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
}
