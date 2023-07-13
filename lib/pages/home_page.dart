import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/db/registers_db.dart';
import 'package:relogio_ponto/models/register.dart';
import '../const/constants.dart';
import '../const/drawerList.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  DataBase db = DataBase();
  Balance balance = new Balance(dayBalance: '', interval: '');

  @override
  Widget build(BuildContext context) {
    db.getCheck(user.uid.toString(), context);

    //var myData = Provider.of<RegisterProvider>(context);
    //var saldo = myData.balanceGet;

    //balance = Provider.of<RegisterProvider>(context, listen: true).balanceGet;

    return Scaffold(
      appBar: myAppBar,
      drawer: NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            mainDivider,
            mainChart,
            mainDivider,
            mainText(""),
            mainDivider,
            mainText('Entrada        |       Saida          '),
            mainDivider,
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
