//calcuator bottom sheet
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
// import 'dart:developer'as dev show log;

Future<void> showBottomPopupCalculator(BuildContext context){
  return showModalBottomSheet(
    context: context,
    builder: (context){
      return const CalculatorPopUp();
    },
  );

}

class CalculatorPopUp extends StatelessWidget {
  const CalculatorPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 500,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Calculator',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SimpleCalculator(
              
            ),
          ),
        ],
      ),
    );
  }
}
