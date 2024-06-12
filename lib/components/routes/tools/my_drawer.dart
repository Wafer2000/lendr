// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/log/login.dart';
import 'package:lendr/components/routes/tools/loading_indicator.dart';
import 'package:lendr/components/routes/views/completed_loans.dart';
import 'package:lendr/components/routes/views/customers.dart';
import 'package:lendr/components/routes/views/debt_collector.dart';
import 'package:lendr/components/routes/views/loan.dart';
import 'package:lendr/components/routes/views/profile.dart';
import 'package:lendr/shared/prefe_users.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController _textController = TextEditingController();

  Future<void> _signOut() async {
    var pref = PreferencesUser();
    LoadingScreen().show(context);

    try {
      await FirebaseAuth.instance.signOut();
      pref.uid = '';
      LoadingScreen().hide();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? 'assets/logo2.png'
                      : 'assets/logo1.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text('P R E S T A M O S'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Loan.routname);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text('C O B R O S'),
                  subtitle: const Text('C O M P L E T A D O S'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, CompletedLoans.routname);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.group,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text('C L I E N T E S'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Customers.routname);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.credit_card,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text('C O B R A D O R E S'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, DebtCollector.routname);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text('P E R F I L'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Profile.routname);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text('C E R R A R  S E S I O N'),
              onTap: () {
                _signOut();
              },
            ),
          )
        ],
      ),
    );
  }
}
