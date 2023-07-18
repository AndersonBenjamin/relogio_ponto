import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:relogio_ponto/ultil/ultil.dart';
import 'package:intl/intl.dart';

class Register {
  String horario;
  String userId;
  String email;
  String tipo;
  String fullDate;

  Register(
      {required this.horario,
      required this.userId,
      required this.email,
      required this.tipo,
      required this.fullDate});
}

class Balance {
  String dayBalance;
  String interval;
  double percentBalance;
  double percentInterval;
  int workday;
  int intervalDay;

  Balance(
      {required this.dayBalance,
      required this.interval,
      required this.percentBalance,
      required this.percentInterval,
      required this.workday,
      required this.intervalDay});
}

class RegisterProvider extends ChangeNotifier {
  List<Register> _reg = [];
  List<Register> _regIn = [];
  List<Register> _regOut = [];

  //Balance _balance = Balance(dayBalance: '', interval: '', percentBalance: 0, per );
  Balance _balance = Balance(
      dayBalance: '',
      interval: '',
      percentBalance: 0,
      percentInterval: 0,
      workday: 540,
      intervalDay: 60);

  List<Register> get registerGet => _reg;
  List<Register> get registerGetIn => _regIn;
  List<Register> get registerGetOut => _regOut;

  Balance get balanceGet => _balance;

  static get percentInterval => null;

  void updateRegister(Register reg) {
    _reg.add(reg);
    notifyListeners();
  }

  void updateRegisterInOrOut() {
    String now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    for (int i = 0; i < _reg.length; i++) {
      (i % 2 == 0) ? _regIn.add(_reg[i]) : _regOut.add(_reg[i]);
    }
    if (_reg.length == 4) {
      _balance.dayBalance = diffDateHhMmSs(
          DateTime.parse(_reg[0].fullDate), DateTime.parse(_reg[3].fullDate));

      _balance.interval = diffDateHhMmSs(
          DateTime.parse(_reg[1].fullDate), DateTime.parse(_reg[2].fullDate));
    } else if (_reg.length == 3) {
      _balance.dayBalance =
          diffDateHhMmSs(DateTime.parse(_reg[0].fullDate), DateTime.parse(now));

      _balance.interval = diffDateHhMmSs(
          DateTime.parse(_reg[1].fullDate), DateTime.parse(_reg[2].fullDate));
    } else if (_reg.length == 2) {
      _balance.dayBalance = diffDateHhMmSs(
          DateTime.parse(_reg[0].fullDate), DateTime.parse(_reg[1].fullDate));

      _balance.interval =
          diffDateHhMmSs(DateTime.parse(_reg[1].fullDate), DateTime.parse(now));
    } else if (_reg.length == 1) {
      _balance.dayBalance =
          diffDateHhMmSs(DateTime.parse(_reg[0].fullDate), DateTime.parse(now));
    }

    List<String> partsDayBalance = _balance.dayBalance.split(':');

    if (_reg.length > 0) {
      _balance.percentBalance = calcularMinutos(
              int.parse(partsDayBalance[0]), (int.parse(partsDayBalance[1]))) /
          _balance.workday;

      List<String> partsInterval = _balance.interval.split(':');
      _balance.percentInterval = calcularMinutos(
              int.parse(partsInterval[0]), (int.parse(partsInterval[1]))) /
          _balance.intervalDay;
    }

    if (_balance.percentBalance < 0) {
      _balance.percentBalance = 0;
    }

    if (_balance.percentBalance > 1) {
      _balance.percentBalance = 1;
    }

    if (_balance.percentInterval < 0) {
      _balance.percentInterval = 0;
    }

    if (_balance.percentInterval > 1) {
      _balance.percentInterval = 1;
    }

    notifyListeners();
  }

  void resetRegister() {
    _reg = [];
    _regIn = [];
    _regOut = [];
    //notifyListeners();
  }
}

String diffDateHhMmSs(DateTime startDate, DateTime endTime) {
  Duration difference = endTime.difference(startDate);

  String formattedDifference = formatDuration(difference);

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

int calcularMinutos(int horas, int minutos) {
  int totalMinutos = (horas * 60) + minutos;
  return totalMinutos;
}
