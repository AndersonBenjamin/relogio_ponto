import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Register {
  String horario;
  String userId;
  String email;
  String tipo;

  Register({
    required this.horario,
    required this.userId,
    required this.email,
    required this.tipo,
  });
}

List<Register> _reg = [];
List<Register> _regIn = [];
List<Register> _regOut = [];

class RegisterProvider with ChangeNotifier {
  List<Register> get registerGet => _reg;
  List<Register> get registerGetIn => _regIn;
  List<Register> get registerGetOut => _regOut;

  void updateRegister(Register reg) {
    _reg.add(reg);
    notifyListeners();
  }

  void updateRegisterInOrOut() {
    for (int i = 0; i < _reg.length; i++) {
      (i % 2 == 0) ? _regIn.add(_reg[i]) : _regOut.add(_reg[i]);
    }
    notifyListeners();
  }

  void resetRegister() {
    _reg = [];
    _regIn = [];
    _regOut = [];
    notifyListeners();
  }
}
