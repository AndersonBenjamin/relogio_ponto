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

class RegisterProvider with ChangeNotifier {
  //List<Register> _reg = [];

  List<Register> get registerGet => _reg; //Get

  void updateRegister(Register reg) {
    _reg.add(reg);
    notifyListeners();
  }

  void resetRegister() {
    _reg = [];
    notifyListeners();
  }
}
