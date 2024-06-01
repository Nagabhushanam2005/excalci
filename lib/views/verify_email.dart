
import 'package:excalci/app_theme.dart';
import 'package:excalci/constants/routes.dart';
import 'package:excalci/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
              children: [
                Text("We've sent a email verifiaction. Please open the link to verify. \n", style: AppTheme.subtitle,),
                Text('Please verify your email address',style: AppTheme.desc,),
                ElevatedButton(
                  onPressed: () async {
                    await AuthService.firebase().verifyEmail();
                    
                  },
                  child: const Text('Send Verification Email'),
                ),
                ElevatedButton(onPressed: (){
                  AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('Restart')),
                
              ],
            ),
      ),
    );
  }
}