import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/home/jobs/jobs_page.dart';
import 'package:flutter_time_tracker_app/app/sign_in/sign_in_page.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:flutter_time_tracker_app/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        //user variable control.
        final User? user = snapshot.data;
        if (user == null) {
          return SignInPage();
        } else {
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: auth.currentUser!.uid),
            child: JobsPage(),
          );
        }
      },
    );
  }
}
