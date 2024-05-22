//Single select bottom sheet

import 'package:flutter/material.dart';


Future<T?> showBottomSingleSelect<T>({
  required BuildContext context,
  required Map<String,IconData> items,
  required String title,
  required Function(T) onSelected,
  T? selectedValue,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return BottomSingleSelect(
        items: items,
        title: title,
        onSelected: onSelected as Function(String),
        selectedValue: selectedValue as String?,
      );
    },
  );
}



class BottomSingleSelect extends StatelessWidget {
  final Map<String,IconData> items;
  final String title;
  final Function(String) onSelected;
  final String? selectedValue;

  const BottomSingleSelect({
    Key? key,
    required this.items,
    required this.title,
    required this.onSelected,
    this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Icon(items.values.elementAt(index)),
                      const SizedBox(width: 10),
                      Text(items.keys.elementAt(index)),
                    ],
                  ),
                  onTap: () {
                    onSelected(items.keys.elementAt(index));
                    Navigator.of(context).pop();
                  },
                  selected: selectedValue == items.keys.elementAt(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}