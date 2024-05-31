// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:excalci/utilities/Widgets/bottom_single_select.dart';
import 'package:excalci/utilities/dialogs/logout_dialog.dart';
import 'package:excalci/constants/preferences_const.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';




class excalciUserView extends StatefulWidget {
  const excalciUserView({super.key});

  @override
  State<excalciUserView> createState() => _excalciUserViewState();
}

class _excalciUserViewState extends State<excalciUserView> {
  // late final SharedPreferences prefs;
  // late var theme;
  // late var selectedCurrency;
  // late var selectedMode;
  // late var forAndroid;
  // late var dailyReminders;

  // bool theme = prefs.getBool('darkTheme') ?? false;
  // String selectedCurrency = prefs.getString('currencyFormatName') ?? 'Rupee';
  // String selectedMode = prefs.getString('defaultMode') ?? 'Cash';
  // bool forAndroid = prefs.getBool('showTips') ?? true;
  // bool dailyReminders = prefs.getBool('dailyReminders') ?? true;

  // bool theme = false;
  String selectedCurrency = 'Rupee';
  String selectedMode = 'Cash';
  bool forAndroid = true;
  bool dailyReminders = true;

  //sync with user prefs
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        // theme = prefs.getBool('darkTheme') ?? false;
        selectedCurrency = prefs.getString('currencyFormatName') ?? 'Rupee';
        selectedMode = prefs.getString('defaultMode') ?? 'Cash';
        forAndroid = prefs.getBool('showTips') ?? true;
        dailyReminders = prefs.getBool('dailyReminders') ?? true;
      });
    });
  }
  

  Icon themeIcon(bool th){
    if (th){
      return const Icon(Icons.dark_mode_sharp,
        color: Colors.blue,
      );
    }
    else{
      return const Icon(Icons.light_mode_sharp,
        color: Colors.blue,
      );
    }
  }

  Icon currencyIcon(String cur){
    return Icon(currencyName[cur]!,
      color: Colors.blue,
    );
  }

  Icon paymentIcon(String mode){
    return Icon(modeItems[mode]!,
      color: Colors.blue,
    );
  }

  // @override
  // void initState() async{
  //   prefs = await SharedPreferences.getInstance();

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/money_bg2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: Row(
              children: [
                SizedBox(width: 300,),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/man.png'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),


        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,

            children: [
              const Text('General Settings',
                textAlign:TextAlign.justify,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              //currency format, default payment mode, show tips toogle, daily reminders toggle
              Card.outlined(
                child: Column(
                  children: [
                    //theme
                    // ListTile(
                    //   leading: themeIcon(theme),
                    //   title: const Text('Theme'),
                    //   trailing: Switch(
                    //     // thumb color (round icon)
                    //     activeColor: AppTheme.background,
                    //     activeTrackColor: AppTheme.primary,
                    //     inactiveThumbColor: Colors.blueGrey.shade600,
                    //     inactiveTrackColor: Colors.grey.shade400,
                    //     splashRadius: 50.0,
                    //     // boolean variable value
                    //     value: theme,
                    //     // changes the state of the switch
                    //     onChanged: (value) async{
                    //       final SharedPreferences prefs = await SharedPreferences.getInstance();

                    //       setState(() {
                    //         theme = value;
                    //         prefs.setBool('darkTheme', value);
                    //       });
                        
                    //     },
                    //   ),
                    // ),
                    ListTile(
                      leading: currencyIcon(selectedCurrency),
                      title: const Text('Currency Format'),
                      onTap: () async{
                        // defalult ₹
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await showBottomSingleSelect(
                          context: context,
                          title: 'Select Currency Format',
                          items: currencyName,
                          selectedValue:  prefs.getString('currencyFormatName') ?? 'Rupee',
                          onSelected: (value)async{
                            await prefs.setString('currencyFormat', currency2[value]!);
                            await prefs.setString('currencyFormatName', value);
                            setState(() {
                              selectedCurrency = value;
                            });
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: paymentIcon(selectedMode),
                      title: const Text('Default Payment Mode'),
                      onTap: () async{
                        // defalult Cash
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await showBottomSingleSelect(
                          context: context,
                          title: 'Select Currency Format',
                          items: modeItems,
                          selectedValue:  prefs.getString('defaultMode') ?? 'Cash',
                          onSelected: (value)async{
                              await prefs.setString('defaultMode', value);
                              setState(() {
                                selectedMode = value;
                              });
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue,
                      ),
                      title: const Text('Show Tips'),
                      trailing: Switch(
                        // thumb color (round icon)
                        activeColor: AppTheme.background,
                        activeTrackColor: AppTheme.primary,
                        inactiveThumbColor: Colors.blueGrey.shade600,
                        inactiveTrackColor: Colors.grey.shade400,
                        splashRadius: 50.0,
                        // boolean variable value
                        value: forAndroid,
                        // changes the state of the switch
                        onChanged: (value) async{
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            forAndroid = value;
                            prefs.setBool('showTips', value);
                          });
                        
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.blue,
                      ),
                      title: const Text('Daily Reminders'),
                      trailing: Switch(
                        // thumb color (round icon)
                        activeColor: AppTheme.background,
                        activeTrackColor: AppTheme.primary,
                        inactiveThumbColor: Colors.blueGrey.shade600,
                        inactiveTrackColor: Colors.grey.shade400,
                        splashRadius: 50.0,
                        // boolean variable value
                        value: dailyReminders,
                        // changes the state of the switch
                        onChanged: (value) async{
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            dailyReminders = value;
                            prefs.setBool('dailyReminders', value);
                          });
                        
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Text('More Settings',
                textAlign:TextAlign.justify,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card.outlined(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: Colors.blue,
                      ),
                      title: const Text('App Settings'),
                      onTap: () {
                        AppSettings.openAppSettings();
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                      ),
                      title: const Text('About'),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'ExCalci',
                          applicationVersion: '1.0.0',
                          applicationIcon: Icon(Icons.account_balance_wallet),
                          children: const [
                            Text('ExCalci is a simple expense tracker app.'),
                          ],
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.blue,
                      ),
                      title: const Text('Logout'),
                      onTap: () async {
                        final shouldLogout= await showLogOutDialog(context);
                        if (shouldLogout){
                          await AuthService.firebase().logOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute,
                            (_)=> false,
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
}