
import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = null,
    this.index = 0,
    this.selectedImagePath = null,
    this.isSelected = false,
    this.animationController,
  });

  IconData? imagePath;
  IconData? selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: Icons.home_outlined,
      selectedImagePath: Icons.home ,
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: Icons.table_chart_outlined,
      selectedImagePath: Icons.table_chart,
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: Icons.account_balance_wallet_outlined,
      selectedImagePath: Icons.account_balance_wallet_rounded,
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: Icons.person_outline,
      selectedImagePath: Icons.person,
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
