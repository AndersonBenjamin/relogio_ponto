import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/balanceControl.dart';
import 'package:relogio_ponto/db/registers_db.dart';
import 'package:relogio_ponto/models/register.dart';
import '../const/constants.dart';
import '../drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  DataBase db = DataBase();
  BalanceControl bControl = new BalanceControl();

  @override
  Widget build(BuildContext context) {
    db.getCheck(user.uid.toString(), context);
    BalanceControl().updateBalance(context);

    return Scaffold(
      appBar: myAppBar,
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
                              Expanded(child: Consumer<RegisterProvider>(
                                builder: ((context, registers, child) {
                                  return ListView.builder(
                                    itemCount: registers.registerGetIn.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(registers
                                            .registerGetIn[index].horario),
                                      );
                                    },
                                  );
                                }),
                              ))
                            ]),
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
                              Expanded(child: Consumer<RegisterProvider>(
                                builder: ((context, registers, child) {
                                  return ListView.builder(
                                    itemCount: registers.registerGetOut.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(registers
                                            .registerGetOut[index].horario),
                                      );
                                    },
                                  );
                                }),
                              ))
                            ]),
                        //color: Colors.black12,    //must be removed
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          db.chekIn(1, user.uid.toString(), user.email.toString(), 'Entrada');
          db.getCheck(user.uid.toString(), context);
        },
        backgroundColor: Colors.redAccent,
        icon: Icon(Icons.app_registration),
        label: const Text(
          'REGISTRAR',
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: buttonNav,
    );
  }
}
