//import 'dart:ffi';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/const/InOut.dart';
import 'package:relogio_ponto/const/drawerList.dart';
import 'package:relogio_ponto/db/registers_db.dart';
import '../const/constants.dart';
import '../main.dart';
import '../models/register.dart';
import 'clock.dart';

class HomePage extends StatefulWidget {
  // Mude de StatelessWidget para StatefulWidget
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer; // Variável para armazenar o Timer

  @override
  void initState() {
    super.initState();
    // Inicie o Timer para atualizar a página a cada 1 segundo
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {}); // Chame setState para reconstruir a página
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Certifique-se de cancelar o Timer ao descartar a página
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser!;
  DataBase db = DataBase();

  @override
  Widget build(BuildContext context) {
    if (!getcheckIni) {
      db.getCheck(user.uid.toString(), context);
      getcheckIni = true;
    }
    Provider.of<RegisterProvider>(context, listen: true).updateBalance();
    return Scaffold(
      appBar: myAppBar,
      drawer: const NaviDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClockApp(),
            mainDivider,
            mainChart(Provider.of<RegisterProvider>(context, listen: true).balanceGet),
            mainDivider,
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
        backgroundColor: Color.fromARGB(255, 99, 32, 185),
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
