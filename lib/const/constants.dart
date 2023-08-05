import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/register.dart';

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
      text: 'Settings',
    )
  ],
);

Row mainChart(Balance balance) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.black45),
                //borderRadius: BorderRadius.circular(12.0),
                color: Colors.white, //add it here
              ),
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              //width: MediaQuery.of(context).size.width * 0.45,
              width: 200,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (const Text(
                    '  Saldo Mes  \n   00:19:20 \n\n\n',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )),
                  (Text(
                    'Intervalo ${balance.interval}',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )),
                  LinearPercentIndicator(
                    lineHeight: 13,
                    percent: balance.percentInterval,
                    progressColor: Colors.green,
                    backgroundColor: Colors.green.shade100,
                  ),
                ],
              ),
              //color: Colors.black12,    //must be removed
            ),
            Container(
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.black45),
                //borderRadius: BorderRadius.circular(12.0),
                color: Colors.white, //add it here
              ),

              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              //width: MediaQuery.of(context).size.width * 0.45,
              width: 200,
              height: 150,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularPercentIndicator(
                    radius: 130,
                    lineWidth: 10,
                    percent: balance.percentBalance,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.blue.shade100,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text('Saldo dia \n\n${balance.dayBalance}'),
                  )
                ],
              ),
              //color: Colors.black12,    //must be removed
            ),
          ],
        ),
      )
    ],
  );
}

var mainDivider = const Divider(height: 30, color: Colors.black54);

Text mainText(String sText) {
  var textReturn = Text(
    sText,
    style: TextStyle(
      letterSpacing: 2,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
  );
  return textReturn;
}

var card = Container(
    width: 300,
    height: 120,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ));
