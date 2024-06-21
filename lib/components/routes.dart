// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:lendr/components/routes/log/login.dart';
import 'package:lendr/components/routes/log/register.dart';
import 'package:lendr/components/routes/views/completed_loans.dart';
import 'package:lendr/components/routes/views/customer_debts.dart';
import 'package:lendr/components/routes/views/debt_collector.dart';
import 'package:lendr/components/routes/views/reports.dart';
import 'package:lendr/components/routes/views/services/new_loan.dart';
import 'package:lendr/components/routes/views/customers.dart';
import 'package:lendr/components/routes/views/guard/extra_data.dart';
import 'package:lendr/components/routes/views/loan.dart';
import 'package:lendr/components/routes/views/profile.dart';
import 'package:lendr/components/routes/views/services/reports/amount_debt.dart';
import 'package:lendr/components/routes/views/services/reports/collectors_loan.dart';
import 'package:lendr/components/routes/views/services/reports/earnings_per_collector.dart';
import 'package:lendr/components/routes/views/services/reports/late_payers.dart';
import 'package:lendr/components/routes/views/services/reports/reliability_clients.dart';
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
        Reports.routname: (context) => const Reports(),
        Register.routname: (context) => const Register(),
        ExtraData.routname: (context) => const ExtraData(),
        Customers.routname: (context) => const Customers(),
        AmountDebt.routname: (context) => const AmountDebt(),
        LatePayers.routname: (context) => const LatePayers(),
        DebtCollector.routname: (context) => const DebtCollector(),
        CustomerDebts.routname: (context) => const CustomerDebts(),
        CollectorsLoan.routname: (context) => const CollectorsLoan(),
        CompletedLoans.routname: (context) => const CompletedLoans(),
        ReliabilityClients.routname: (context) => const ReliabilityClients(),
        EarningsPerCollector.routname: (context) => const EarningsPerCollector(),
      },
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}