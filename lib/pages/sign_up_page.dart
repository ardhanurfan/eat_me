import 'package:eat_me/widgets/custom_dropdown_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/theme.dart';
import '../providers/page_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullNameController =
      TextEditingController(text: '');
  final TextEditingController usernameController =
      TextEditingController(text: '');
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');
  bool isLoading = false;
  String role = "";

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    final navigator = Navigator.of(context);
    final message = ScaffoldMessenger.of(context);

    handleSignUp() async {
      setState(() {
        isLoading = true;
      });

      if (await userProvider.signUp(
          email: emailController.text,
          password: passwordController.text,
          name: fullNameController.text,
          username: usernameController.text,
          role: role)) {
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

    Widget inputFullName() {
      return CustomTextFormField(
        icon: Icon(
          Icons.person_rounded,
          color: primaryColor,
        ),
        hintText: 'Your Full Name',
        controller: fullNameController,
        radiusBorder: defaultRadius,
      );
    }

    Widget inputUsername() {
      return CustomTextFormField(
        icon: Icon(
          Icons.radio_button_checked_rounded,
          color: primaryColor,
        ),
        hintText: 'Your Username',
        controller: usernameController,
        radiusBorder: defaultRadius,
      );
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
        buttonText: "Sign Up",
        widthButton: double.infinity,
        heightButton: 50,
        onPressed: handleSignUp,
        isLoading: isLoading,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(defaultMargin),
          children: [
            Text(
              "Sign Up",
              style:
                  primaryColorText.copyWith(fontSize: 24, fontWeight: semibold),
            ),
            Text(
              "Register and Enjoy Your Eats",
              style: greyText.copyWith(fontSize: 14),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Full Name",
              style: darkText.copyWith(fontSize: 16, fontWeight: medium),
            ),
            const SizedBox(
              height: 12,
            ),
            inputFullName(),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Username",
              style: darkText.copyWith(fontSize: 16, fontWeight: medium),
            ),
            const SizedBox(
              height: 12,
            ),
            inputUsername(),
            const SizedBox(
              height: 20,
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
              height: 20,
            ),
            Text(
              "Role",
              style: darkText.copyWith(fontSize: 16, fontWeight: medium),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomDropdownFormField(
                hintText: "Select role",
                items: const ["user", "penjual"],
                radiusBorder: 12,
                onChanged: (val) {
                  if (val != null) {
                    role = val;
                    print(val);
                  }
                }),
            const SizedBox(
              height: 30,
            ),
            submitButton(),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: greyText.copyWith(fontSize: 12),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-in');
                  },
                  child: Text(
                    "Sign In",
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
