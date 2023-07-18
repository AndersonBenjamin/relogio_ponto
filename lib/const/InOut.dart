import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/models/register.dart';

class InOut extends StatelessWidget {
  InOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 150,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Consumer<RegisterProvider>(
                          builder: ((context, registers, child) {
                            return ListView.builder(
                              itemCount: registers.registerGetIn.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      registers.registerGetIn[index].horario),
                                );
                              },
                            );
                          }),
                        ))
                      ]),
                  //color: Colors.black12,    //must be removed
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white, //add it here
                  ),

                  margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 150,

                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Consumer<RegisterProvider>(
                          builder: ((context, registers, child) {
                            return ListView.builder(
                              itemCount: registers.registerGetOut.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      registers.registerGetOut[index].horario),
                                );
                              },
                            );
                          }),
                        ))
                      ]),
                  //color: Colors.black12,    //must be removed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
