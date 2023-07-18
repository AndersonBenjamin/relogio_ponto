import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relogio_ponto/const/InOut.dart';
import 'package:relogio_ponto/db/registers_db.dart';
import '../const/constants.dart';
import '../const/drawerList.dart';
import '../const/maihChart.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  DataBase db = DataBase();
  @override
  Widget build(BuildContext context) {
    db.getCheck(user.uid.toString(), context);
    return Scaffold(
      appBar: myAppBar,
      drawer: NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            mainDivider,
            MainChart(),
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
