//import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/const/InOut.dart';
import 'package:relogio_ponto/const/drawerList.dart';
import 'package:relogio_ponto/db/registers_db.dart';
import '../const/constants.dart';
import '../models/register.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  DataBase db = DataBase();

  bool getcheckIni = false;

  @override
  Widget build(BuildContext context) {
    if (!getcheckIni) {
      db.getCheck(user.uid.toString(), context);
    }
    //var myData = Provider.of<RegisterProvider>(context);
    //var saldo = myData.balanceGet;

    Balance balance =
        Provider.of<RegisterProvider>(context, listen: true).balanceGet;

    Provider.of<RegisterProvider>(context, listen: false)
        .updateRegisterInOrOut();

    return Scaffold(
      appBar: myAppBar,
      //drawer: NavigationDrawer(),
      drawer: const NaviDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            mainDivider,
            mainChart(balance),
            mainDivider,
            mainText(""),
            mainDivider,
            mainText('Entrada        |       Saida          '),
            InOut(),
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
