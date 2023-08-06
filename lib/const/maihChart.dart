import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/models/register.dart';

class MainChart extends StatelessWidget {
  Balance balance = Balance(
      dayBalance: '',
      interval: '',
      percentBalance: 0,
      percentInterval: 0,
      workday: 540,
      intervalDay: 60);

  MainChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    balance = Provider.of<RegisterProvider>(context, listen: false).balanceGet;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(12.0),
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
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(12.0),
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
                        progressColor: Colors.red,
                        backgroundColor: Colors.red.shade100,
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
      ),
    );
  }
}
