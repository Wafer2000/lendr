// ignore_for_file: avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendr/components/routes/tools/helper_functions.dart';
import 'package:lendr/components/routes/tools/loading_indicator.dart';
import 'package:lendr/components/routes/tools/my_button.dart';
import 'package:lendr/components/routes/tools/my_textfield.dart';
import 'package:lendr/components/routes/views/loan.dart';
import 'package:lendr/shared/prefe_users.dart';
import 'package:lendr/style/global_colors.dart';

class NewLoan extends StatefulWidget {
  static const String routname = '/new_loan';
  const NewLoan({super.key});

  @override
  State<NewLoan> createState() => _NewLoanState();
}

class _NewLoanState extends State<NewLoan> {
  final TextEditingController clientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController tipePayController = TextEditingController();
  final TextEditingController quotaNumberController = TextEditingController();
  final TextEditingController quotaMaxController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController hourController = TextEditingController();

  String clientId = '';
  List<String>? _dropDownItems = [];
  final _pref = PreferencesUser();

  @override
  void dispose() {
    super.dispose();
  }

  double _quota = 0;

  void _calculateQuota() {
    try {
      final amount = int.parse(amountController.text);
      final percentage = int.parse(percentageController.text);
      final quotaMax = int.parse(quotaMaxController.text);

      _quota = (amount + (amount * (percentage / 100))) / quotaMax;
      quotaNumberController.text = _quota.toString();
      setState(() {});
    } catch (e) {
      _quota = 0;
    }
  }

  DateTime calculateNewDate(DateTime today, String tipePay) {
    DateTime newDate;
    switch (tipePay) {
      case 'Diario':
        newDate = today.add(Duration(days: 1));
        break;
      case 'Semanal':
        newDate = today.add(Duration(days: 7));
        break;
      case 'Quincenal':
        newDate = today.add(Duration(days: 15));
        break;
      case 'Mensual':
        newDate = today.add(Duration(days: 30));
        break;
      case 'Semestral':
        newDate = today.add(Duration(days: 180));
        break;
      case 'Anual':
        newDate = today.add(Duration(days: 365));
        break;
      default:
        newDate = today;
        break;
    }
    return newDate;
  }

  String calculateNewDateString(DateTime today, String tipePay) {
    DateTime newDate = calculateNewDate(today, tipePay);
    return DateFormat('yyyy-MM-dd').format(newDate);
  }

  Future<void> KeepLoan() async {
    LoadingScreen().show(context);

    final now = DateTime.now();
    final hcreate = DateFormat('HH:mm:ss').format(now);
    final fcreate = DateFormat('yyyy-MM-dd').format(now);

    DateTime today = DateTime.now();
    String tipePay = tipePayController.text;
    String newDateString = calculateNewDateString(today, tipePay);

    double quotaNumber = double.parse(quotaNumberController.text);
int quotaNumberInt = quotaNumber.truncate();

    final int loanAmount =
        int.parse(quotaMaxController.text) * quotaNumberInt;

    if (clientController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debes sleccionar un cliente', context);
    } else if (clientId == '') {
      LoadingScreen().hide();
      displayMessageToUser('No tiene un id el cliente', context);
    } else if (amountController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar una cantidad', context);
    } else if (percentageController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar un porcentaje', context);
    } else if (tipePayController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar un tipo de pago', context);
    } else if (quotaNumberController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar un numero de cuotas', context);
    } else if (quotaMaxController.text == '') {
      LoadingScreen().hide();
      displayMessageToUser('Debe colocar unas cuotas maximas', context);
    } else {
      FirebaseFirestore.instance
          .collection('Prestamos+${_pref.uid}')
          .doc()
          .set({
        'client': clientController.text,
        'clientId': clientId,
        'amount': int.parse(amountController.text),
        'loanAmount': loanAmount,
        'percentage': int.parse(percentageController.text),
        'tipePay': tipePayController.text,
        'quotaNumber': quotaNumberInt,
        'quotaMax': int.parse(quotaMaxController.text),
        'state': false,
        'date': fcreate,
        'hour': hcreate,
        'proxPay': newDateString
      });

      final documentSnapshot = await FirebaseFirestore.instance
          .collection('Prestamos+${_pref.uid}')
          .doc('General')
          .get();

      final data = documentSnapshot.data();

      final clientSnapshot = await FirebaseFirestore.instance
          .collection('Clientes+${_pref.uid}')
          .doc(clientId)
          .get();

      final client = clientSnapshot.data();

      final int loanAmounts =
            data?['loanAmounts'] + int.parse(amountController.text);
        final int collectAmount = data?['collectAmount'] + loanAmount;
        final int loans = data?['loans'] + 1;

        FirebaseFirestore.instance
            .collection('Prestamos+${_pref.uid}')
            .doc('General')
            .update({
          'loans': loans,
          'loanAmounts': loanAmounts,
          'collectAmount': collectAmount
        });

        final int amount = client!['amount'] + int.parse(amountController.text);
        final int collect = client['collect'] + loanAmount;
        final int debts = client['debts'] + 1;

        FirebaseFirestore.instance
            .collection('Clientes+${_pref.uid}')
            .doc(clientId)
            .update({'amount': amount, 'debts': debts, 'collect': collect});
        clientController.clear();
        amountController.clear();
        percentageController.clear();
        tipePayController.clear();
        quotaNumberController.clear();
        quotaMaxController.clear();
        dateController.clear();
        hourController.clear();
        clientId = '';
        _quota = 0;
        LoadingScreen().hide();
        displayMessageToUser('Prestamo guardado', context);
        Navigator.pushReplacementNamed(context, Loan.routname);
    }
  }

  @override
  Widget build(BuildContext context) {
    amountController.addListener(_calculateQuota);
    percentageController.addListener(_calculateQuota);
    quotaMaxController.addListener(_calculateQuota);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: 200,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? 'assets/logo2.png'
                        : 'assets/logo1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Clientes+${_pref.uid}')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  _dropDownItems = snapshot.data!.docs
                      .map((doc) =>
                          '${doc['firstname']} ${doc['middlename']} ${doc['lastname']} ${doc['secondlastname']}')
                      .cast<String>()
                      .toList();

                  return DropdownButtonFormField<String>(
                    value: clientController.text.isNotEmpty
                        ? clientController.text
                        : null,
                    items: _dropDownItems?.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      final DocumentSnapshot<Map<String, dynamic>> doc =
                          snapshot.data!.docs.firstWhere((doc) =>
                              '${doc['firstname']} ${doc['middlename']} ${doc['lastname']} ${doc['secondlastname']}' ==
                              value);
                      final String docId = doc.id;
                      setState(() {
                        clientId = docId;
                        print(docId);
                        clientController.text = value!;
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                    decoration: InputDecoration(
                      labelText: 'Cliente',
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      floatingLabelStyle: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? MyColor.black().color
                                  : MyColor.white().color),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColor.black().color
                                    : MyColor.white().color),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                value: tipePayController.text.isNotEmpty
                    ? tipePayController.text
                    : null,
                items: const [
                  DropdownMenuItem<String>(
                      value: 'Diario', child: Text('Diario')),
                  DropdownMenuItem<String>(
                      value: 'Semanal', child: Text('Semanal')),
                  DropdownMenuItem<String>(
                      value: 'Quincenal', child: Text('Quincenal')),
                  DropdownMenuItem<String>(
                      value: 'Mensual', child: Text('Mensual')),
                  DropdownMenuItem<String>(
                      value: 'Semestral', child: Text('Semestral')),
                  DropdownMenuItem<String>(
                      value: 'Anual', child: Text('Anual')),
                ],
                onChanged: (String? value) {
                  setState(() {
                    tipePayController.text = value!;
                    print('Tipo: ${tipePayController.text}');
                  });
                },
                icon: const Icon(Icons.arrow_drop_down),
                decoration: InputDecoration(
                  labelText: 'Tipo de Pago',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  floatingLabelStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? MyColor.black().color
                          : MyColor.white().color),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? MyColor.black().color
                            : MyColor.white().color),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                labelText: 'Monto a Prestar',
                obscureText: false,
                controller: amountController,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                labelText: 'Porcentaje',
                obscureText: false,
                controller: percentageController,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                labelText: 'Maximo de Cuotas',
                obscureText: false,
                controller: quotaMaxController,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                labelText: 'Monto por Cuota',
                obscureText: false,
                controller: quotaNumberController,
              ),
              const SizedBox(
                height: 30,
              ),
              MyButton(text: 'Guardar', onTap: KeepLoan)
            ],
          ),
        ),
      ),
    );
  }
}
