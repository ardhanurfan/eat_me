import 'package:eat_me/providers/page_provider.dart';
import 'package:eat_me/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    final navigator = Navigator.of(context);
    final message = ScaffoldMessenger.of(context);

    handleSignIn() async {
      setState(() {
        isLoading = true;
      });

      if (await userProvider.signIn(
        email: emailController.text,
        password: passwordController.text,
      )) {
        pageProvider.setCurrPage = 0;
        navigator.pushNamedAndRemoveUntil('/main', (route) => false);
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

    Widget inputEmail() {
      return CustomTextFormField(
        icon: Icon(
          Icons.email_sharp,
          color: primaryColor,
        ),
        hintText: 'Your Email',
        controller: emailController,
        radiusBorder: defaultRadius,
      );
    }

    Widget inputPassword() {
      return CustomTextFormField(
        icon: Icon(Icons.lock, color: primaryColor),
        controller: passwordController,
        hintText: 'Your Password',
        isPassword: true,
        radiusBorder: defaultRadius,
      );
    }

    Widget submitButton() {
      return CustomButton(
        radiusButton: defaultRadius,
        buttonColor: primaryColor,
        buttonText: "Sign In",
        widthButton: double.infinity,
        isLoading: isLoading,
        onPressed: handleSignIn,
        heightButton: 50,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(defaultMargin),
          children: [
            Text(
              "Login",
              style:
                  primaryColorText.copyWith(fontSize: 24, fontWeight: semibold),
            ),
            Text(
              "Sign In to Countinue",
              style: greyText.copyWith(fontSize: 14),
            ),
            const SizedBox(
              height: 70,
            ),
            Text(
              "Email Address",
              style: darkText.copyWith(fontSize: 16, fontWeight: medium),
            ),
            const SizedBox(
              height: 12,
            ),
            inputEmail(),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Password",
              style: darkText.copyWith(fontSize: 16, fontWeight: medium),
            ),
            const SizedBox(
              height: 12,
            ),
            inputPassword(),
            const SizedBox(
              height: 30,
            ),
            submitButton(),
            const SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: greyText.copyWith(fontSize: 12),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-up');
                  },
                  child: Text(
                    "Sign Up",
                    style: secondaryColorText.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
