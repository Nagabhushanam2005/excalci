import 'package:flutter/material.dart';
import 'package:excalci/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyItemDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content:'Cannot share an empty/invalid item!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
