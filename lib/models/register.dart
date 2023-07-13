import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:relogio_ponto/ultil/ultil.dart';

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

  Balance({required this.dayBalance, required this.interval});
}

class RegisterProvider extends ChangeNotifier {
  List<Register> _reg = [];
  List<Register> _regIn = [];
  List<Register> _regOut = [];

  Balance _balance = Balance(dayBalance: '', interval: '');

  List<Register> get registerGet => _reg;
  List<Register> get registerGetIn => _regIn;
  List<Register> get registerGetOut => _regOut;
  Balance get balanceGet => _balance;

  void updateRegister(Register reg) {
    _reg.add(reg);
    notifyListeners();
  }

  void updateRegisterInOrOut() {
    for (int i = 0; i < _reg.length; i++) {
      (i % 2 == 0) ? _regIn.add(_reg[i]) : _regOut.add(_reg[i]);
    }
    //if (_reg.length == 4) {
    //  _balance.dayBalance = diffDateHhMmSs(
    //      DateTime.parse(_reg[0].fullDate), DateTime.parse(_reg[0].fullDate));
    //}
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
