import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relogio_ponto/models/register.dart';

class BalanceControl {
  Future updateBalance(BuildContext context) async {
    Consumer<RegisterProvider>(
      builder: ((context, registers, child) {
        return ListView.builder(
          itemCount: registers.registerGetIn.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(registers.registerGetIn[index].horario),
            );
          },
        );
      }),
    );

    /*   final instanceRegister = Consumer<RegisterProvider>()
    final instanceRegisterIn =
        Provider.of<RegisterProvider>(context).registerGetIn;
    final instanceRegisterOut =
        Provider.of<RegisterProvider>(context).registerGetOut;
*/
    //print(myDataModel);
  }
}
