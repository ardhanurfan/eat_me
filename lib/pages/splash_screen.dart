import 'dart:async';

import 'package:eat_me/providers/user_provider.dart';
import 'package:eat_me/shared/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Timer(const Duration(seconds: 3), () async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      final navigator = Navigator.of(context);

      if (currentUser == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/sign-in', (route) => false);
      } else {
        if (await userProvider.getUserById(id: currentUser.uid)) {
          navigator.pushNamedAndRemoveUntil('/main', (route) => false);
        } else {
          navigator.pushNamedAndRemoveUntil('/sign-in', (route) => false);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 250,
            ),
            Text(
              "Expired Date App",
              style: whiteText.copyWith(
                fontWeight: regular,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
