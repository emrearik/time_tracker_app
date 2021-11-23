import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker App"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _signOut,
              child: Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text("HomePage"),
      ),
    );
  }
}
