import 'package:flutter/material.dart';
import 'dart:async';

class ClockApp extends StatefulWidget {
  @override
  _ClockAppState createState() => _ClockAppState();
}

class _ClockAppState extends State<ClockApp> {
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    // Inicia o timer para atualizar o relógio a cada segundo.
    Timer.periodic(Duration(seconds: 1), _updateTime);
  }

  void _updateTime(Timer timer) {
    // Obtém a hora atual.
    DateTime now = DateTime.now();
    // Formata a hora no formato HH:MM:SS.
    String formattedTime = "${twoDigits(now.hour)}:${twoDigits(now.minute)}:${twoDigits(now.second)}";
    // Atualiza a interface do usuário com a hora atual.

    if (mounted) {
      setState(() {
        _currentTime = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Hora Atual:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            _currentTime,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

String twoDigits(int n) => n.toString().padLeft(2, '0');
