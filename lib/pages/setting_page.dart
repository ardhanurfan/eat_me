import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/theme.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final navigator = Navigator.of(context);
    final message = ScaffoldMessenger.of(context);

    handleSignOut() async {
      setState(() {
        isLoading = true;
      });

      if (await userProvider.signOut()) {
        navigator.pushNamedAndRemoveUntil('/sign-in', (route) => false);
      } else {
        message.removeCurrentSnackBar();
        message.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              userProvider.errorMessage,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget content() {
      return Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?name=${userProvider.user.name}+&color=673AB7&background=EBF4FF'),
          ),
          const SizedBox(height: 16),
          Text(
            userProvider.user.name,
            style: darkText.copyWith(fontSize: 18, fontWeight: semibold),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                  child: Text(
                'Username : ',
                style: greyText.copyWith(fontSize: 14, fontWeight: medium),
              )),
              Text(userProvider.user.username)
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: Text(
                'Email : ',
                style: greyText.copyWith(fontSize: 14, fontWeight: medium),
              )),
              Text(userProvider.user.email)
            ],
          ),
        ],
      );
    }

    Widget signOutButton() {
      return Container(
          margin: const EdgeInsets.only(top: 32),
          child: CustomButton(
            onPressed: handleSignOut,
            buttonColor: Colors.red,
            buttonText: 'Log Out',
            heightButton: 50,
            radiusButton: defaultRadius,
            widthButton: double.infinity,
            isLoading: isLoading,
          ));
    }

    return Scaffold(
      backgroundColor: white2,
      body: SafeArea(
        child: ListView(
          padding:
              EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 60),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius),
                color: white,
              ),
              child: Column(
                children: [
                  content(),
                  signOutButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
