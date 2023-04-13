import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../drawerList.dart';

class CheckIn_CheckOut extends StatelessWidget {
  CheckIn_CheckOut({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurple, actions: [
        IconButton(
          onPressed: signUserOut,
          icon: Icon(Icons.logout),
        ),
      ]),
      drawer: NavigationDrawer(),
      body: Center(
          child: Text(
        "LOGGED IN! " + user.email!,
        style: TextStyle(fontSize: 20),
      )),
    );
  }
}
