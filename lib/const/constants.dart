import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

var myAppBar = AppBar(
  backgroundColor: Colors.redAccent,
  actions: const [
    IconButton(
      onPressed: signUserOut,
      icon: Icon(Icons.logout),
    ),
  ],
);

var buttonNav = const GNav(
  backgroundColor: Colors.redAccent,
  color: Colors.white,
  activeColor: Colors.white,
  gap: 8,
  tabs: [
    GButton(
      icon: Icons.home,
      text: 'Home',
    ),
    GButton(
      icon: Icons.punch_clock_sharp,
      text: 'Registers',
    ),
    GButton(
      icon: Icons.search,
      text: 'Search',
    ),
    GButton(
      icon: Icons.settings,
      text: 'Search',
    )
  ],
);
