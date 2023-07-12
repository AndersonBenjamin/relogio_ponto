import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Balance {
  String dayBalance;
  String interval;

  Balance({required this.dayBalance, required this.interval});
}

class BalanceProvider extends ChangeNotifier {
  Balance _Balance = new Balance(dayBalance: '', interval: '');

  Balance get getBalance => _Balance;

  void updateBalance(Balance paramBalance) {
    _Balance = paramBalance;
    notifyListeners();
  }

  void resetBalance() {
    _Balance = new Balance(dayBalance: '', interval: '');
    notifyListeners();
  }
}
