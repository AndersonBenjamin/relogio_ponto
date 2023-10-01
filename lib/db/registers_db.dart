import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/register.dart';

class DataBase {
  Future<dynamic> chekIn(int id, String userId, String email, String tipo) async {
    String now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    await FirebaseFirestore.instance.collection('registros').add({'id': id, 'horario': now, 'id_user': userId, 'e_mail': email, 'tipo': tipo});
  }

  Future getCheck(String userId, BuildContext context) async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Provider.of<RegisterProvider>(context, listen: false).resetRegister();

    List<Register> tempReg = [];
    RegisterProvider instanceRegisterProvider = RegisterProvider();

    await FirebaseFirestore.instance
        .collection('registros')
        .where('horario', isGreaterThan: today)
        .where('id_user', isEqualTo: userId)
        .orderBy('horario', descending: false)
        .limit(4)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              Map<String, dynamic> data = element.data();
              Register regs = Register(
                horario: data['horario'].toString().substring(11),
                fullDate: data['horario'].toString(),
                userId: data['id_user'].toString(),
                email: data['e_mail'].toString(),
                tipo: data['tipo'].toString(),
              );
              Provider.of<RegisterProvider>(context, listen: false).updateRegister(regs);
            },
          ),
        );
    //Provider.of<RegisterProvider>(context, listen: false).resetRegister();
    Provider.of<RegisterProvider>(context, listen: false).updateRegisterInOrOut();

    //Provider.of<RegisterProvider>(context, listen: false).updateBalance();
  }
}
