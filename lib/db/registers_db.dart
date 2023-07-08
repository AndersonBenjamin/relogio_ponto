import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/register.dart';

class DataBase {
  Future<dynamic> chekIn(
      int id, String userId, String email, String tipo) async {
    String now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    await FirebaseFirestore.instance.collection('registros').add({
      'id': id,
      'horario': now,
      'id_user': userId,
      'e_mail': email,
      'tipo': tipo
    });
  }

  Future getCheck(String userId) async {
    RegisterProvider().resetRegister();

    await FirebaseFirestore.instance
        .collection('registros')
        .where('id_user', isEqualTo: userId)
        .orderBy('horario', descending: true)
        .limit(10)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              Map<String, dynamic> data =
                  element.data() as Map<String, dynamic>;
              Register regs = Register(
                horario: data['horario'].toString(),
                userId: data['id_user'].toString(),
                email: data['e_mail'].toString(),
                tipo: data['tipo'].toString(),
              );
              RegisterProvider().updateRegister(regs);
            },
          ),
        );
  }
}
