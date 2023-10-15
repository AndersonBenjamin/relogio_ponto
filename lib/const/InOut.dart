import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/models/register.dart';

import 'constants.dart';

class InOut extends StatelessWidget {
  const InOut({Key? key}) : super(key: key);

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
                  margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 250,
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Text(
                      'Entrada',
                      textAlign: TextAlign.center,
                    ),
                    Expanded(child: Consumer<RegisterProvider>(
                      builder: ((context, registers, child) {
                        return ListView.builder(
                          itemCount: registers.registerGetIn.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                registers.registerGetIn[index].horario,
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        );
                      }),
                    ))
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 250,
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Text(
                      'Saida',
                      textAlign: TextAlign.center,
                    ),
                    Expanded(child: Consumer<RegisterProvider>(
                      builder: ((context, registers, child) {
                        return ListView.builder(
                          itemCount: registers.registerGetOut.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                registers.registerGetOut[index].horario,
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        );
                      }),
                    ))
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
