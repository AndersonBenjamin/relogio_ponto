import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetRegisters extends StatelessWidget {
  final String registers;

  GetRegisters({required this.registers});

  @override
  Widget build(BuildContext context) {
    CollectionReference reg =
        FirebaseFirestore.instance.collection('registros');

    return FutureBuilder<DocumentSnapshot>(
      future: reg.doc(registers).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['horario']}' + ' | ' + '${data['tipo']}');
        }
        return const Text('loaging...');
      },
    );
  }
}

class GetRegistersIn extends StatelessWidget {
  final String registers;

  GetRegistersIn({required this.registers});

  @override
  Widget build(BuildContext context) {
    CollectionReference reg =
        FirebaseFirestore.instance.collection('registros');

    return FutureBuilder<DocumentSnapshot>(
      future: reg.doc(registers).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['horario']}');
        }

        return const Text('loaging...');
      },
    );
  }
}