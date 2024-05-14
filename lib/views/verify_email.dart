
import 'package:excalci/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

      body: Column(
            children: [
              const Text("We've sent a email verifiaction. Please open the link to verify. \n"),
              const Text('Please verify your email address'),
              ElevatedButton(
                onPressed: () async {
                  final user=FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  
                },
                child: const Text('Send Verification Email'),
              ),
              ElevatedButton(onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Restart')),
              
            ],
          ),
    );
  }
}