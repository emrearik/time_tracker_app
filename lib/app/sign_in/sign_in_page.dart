import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/sign_in/email_sign_in_page.dart';
import 'package:flutter_time_tracker_app/app/sign_in/sign_in_model.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In Page"),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.purple,
                  textColor: Colors.white,
                  child: Text("Sign in Anonymously"),
                ),
                SizedBox(height: 10),
                MaterialButton(
                  onPressed: () => _openEmailSignInPage(),
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: Text("Sign in with Email and Password"),
                ),
              ],
            ),
          ),
        ));
  }

  _openEmailSignInPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EmailSignInPage.create(context)),
    );
  }
}
