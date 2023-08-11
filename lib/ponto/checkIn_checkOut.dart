import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
          icon: const Icon(Icons.logout),
        ),
      ]),
      //drawer: NavigationDrawer(),
      //drawer: NavigationDrawer(),
      body: Center(
          child: Text(
        "LOGGED IN! ${user.email!}",
        style: const TextStyle(fontSize: 20),
      )),
    );
  }
}
