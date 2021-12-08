import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransanctions;

  const Chart({Key? key, required this.recentTransanctions}) : super(key: key);

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < recentTransanctions.length; i++) {
        if (recentTransanctions[i].date.day == weekDay.day &&
            recentTransanctions[i].date.month == weekDay.month &&
            recentTransanctions[i].date.year == weekDay.year) {
          totalSum += recentTransanctions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    });
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Row(
        children: groupedTransactionsValues.map((data) {
          return ChartBar(
              data['day'] as String,
              data['amount'] as double,
              totalSpending == 0.0
                  ? 0.0
                  : ((data['amount'] as double) / totalSpending));
        }).toList(),
      ),
    );
  }
}