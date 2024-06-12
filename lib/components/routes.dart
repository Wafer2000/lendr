// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:lendr/components/routes/log/login.dart';
import 'package:lendr/components/routes/log/register.dart';
import 'package:lendr/components/routes/views/completed_loans.dart';
import 'package:lendr/components/routes/views/customer_debts.dart';
import 'package:lendr/components/routes/views/debt_collector.dart';
import 'package:lendr/components/routes/views/services/new_loan.dart';
import 'package:lendr/components/routes/views/customers.dart';
import 'package:lendr/components/routes/views/guard/extra_data.dart';
import 'package:lendr/components/routes/views/loan.dart';
import 'package:lendr/components/routes/views/profile.dart';
import 'package:lendr/shared/prefe_users.dart';
import 'package:lendr/style/theme/dark.dart';
import 'package:lendr/style/theme/light.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  final prefs = PreferencesUser();
  
  @override
  Widget build(BuildContext context) {
  final uid = prefs.uid;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: uid != null && uid != '' ? Loan.routname : Login.routname,
      routes: {
        Loan.routname: (context) => const Loan(),
        Login.routname: (context) => const Login(),
        Profile.routname: (context) => const Profile(),
        NewLoan.routname: (context) => const NewLoan(),
        Register.routname: (context) => const Register(),
        ExtraData.routname: (context) => const ExtraData(),
        Customers.routname: (context) => const Customers(),
        DebtCollector.routname: (context) => const DebtCollector(),
        CustomerDebts.routname: (context) => const CustomerDebts(),
        CompletedLoans.routname: (context) => const CompletedLoans(),
      },
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}