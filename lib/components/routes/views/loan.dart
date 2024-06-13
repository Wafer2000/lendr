// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendr/tools/helper_functions.dart';
import 'package:lendr/tools/loading_indicator.dart';
import 'package:lendr/tools/my_drawer.dart';
import 'package:lendr/tools/my_numberfield.dart';
import 'package:lendr/components/routes/views/services/new_loan.dart';
import 'package:lendr/shared/prefe_users.dart';
import 'package:lendr/style/global_colors.dart';

class Loan extends StatefulWidget {
  static const String routname = '/loan';
  const Loan({super.key});

  @override
  State<Loan> createState() => _HomeState();
}

class _HomeState extends State<Loan> {
  final TextEditingController paymentCreditController = TextEditingController();
  final _pref = PreferencesUser();

  @override
  void dispose() {
    super.dispose();
  }

  void view_history(id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Prestamos+${_pref.uid}')
                    .doc(id)
                    .collection('Historial')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  final service = snapshot.data?.docs;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                  if (snapshot.data == null) {
                    return Scaffold(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      body: const Stack(
                        children: [
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                'No hay Datos',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Historial de los Abonos',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'ID',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Cliente',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Cobrador',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Abono',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Deuda Faltante',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Fecha',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Hora',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Estado',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows: service!.asMap().entries.map((entry) {
                                Map<String, dynamic> data =
                                    entry.value.data() as Map<String, dynamic>;
                                String docId = entry.value.id;
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text('${entry.key + 1}')),
                                    DataCell(Text('${data['client']}')),
                                    DataCell(Text('${data['worker']}')),
                                    DataCell(Text(NumberFormat.currency(
                                            locale: 'es', symbol: '\$')
                                        .format(data['cashPayment']))),
                                    DataCell(Text(NumberFormat.currency(
                                            locale: 'es', symbol: '\$')
                                        .format(data['totalDebt']))),
                                    DataCell(Text('${data['date']}')),
                                    DataCell(Text('${data['hour']}')),
                                    DataCell(data['cashPayment'] == 0
                                        ? Text('En mora')
                                        : Text('Pago')),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
  }

  void new_payment_credit(id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Llene todos los campos'),
          icon: const Icon(Icons.book),
          shadowColor: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyNumberField(
                    labelText: 'Abono a la deuda',
                    obscureText: false,
                    controller: paymentCreditController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
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
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B897F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      paymentCreditController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyColor.shark().color
                        : MyColor.iron().color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      LoadingScreen().show(context);

                      final DocumentSnapshot documentSnapshot =
                          await FirebaseFirestore.instance
                              .collection('Prestamos+${_pref.uid}')
                              .doc(id)
                              .get();

                      final data =
                          documentSnapshot.data() as Map<String, dynamic>;

                      final now = DateTime.now();
                      final hcreate = DateFormat('HH:mm:ss').format(now);
                      final fcreate = DateFormat('yyyy-MM-dd').format(now);

                      DateTime calculateNewDate(
                          DateTime today, String tipePay) {
                        DateTime newDate;
                        switch (tipePay) {
                          case 'Diario':
                            newDate = today.add(Duration(days: 1));
                            break;
                          case 'Semanal':
                            newDate = today.add(Duration(days: 7));
                            break;
                          case 'Mensual':
                            newDate = today.add(Duration(days: 30));
                            break;
                          case 'Bimestral':
                            newDate = today.add(Duration(days: 60));
                            break;
                          case 'Trimestral':
                            newDate = today.add(Duration(days: 90));
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

                      final userSnapshot = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(_pref.uid)
                          .get();

                      final user = userSnapshot.data();

                      final int balance = user?['balance'] +
                          int.parse(paymentCreditController.text);

                      final int paidPrestamo = data['paid'] + 1;

                      String calculateNewDateString(
                          DateTime today, String tipePay) {
                        DateTime newDate = calculateNewDate(today, tipePay);
                        return DateFormat('yyyy-MM-dd').format(newDate);
                      }

                      String tipePay = data['tipePay'];
                      String newDateString =
                          calculateNewDateString(now, tipePay);

                      final int loanAmount = data['loanAmount'] -
                          int.parse(paymentCreditController.text);

                      final generalSnapshot = await FirebaseFirestore.instance
                          .collection('Prestamos+${_pref.uid}')
                          .doc('General')
                          .get();

                      if (int.parse(paymentCreditController.text) >=
                          data['quotaNumber']) {
                        if (generalSnapshot.exists) {
                          final doc =
                              generalSnapshot.data() as Map<String, dynamic>;

                          final int paidGeneral = doc['paid'] + 1;

                          final int collectAmount = doc['collectAmount'] -
                              int.parse(paymentCreditController.text);
                          final int earnings = doc['earnings'] +
                              int.parse(paymentCreditController.text);

                          final clientSnapshot = await FirebaseFirestore
                              .instance
                              .collection('Clientes+${_pref.uid}')
                              .doc(data['clientId'])
                              .get();

                          final workSnapshot = await FirebaseFirestore.instance
                              .collection('Cobradores+${_pref.uid}')
                              .doc(data['workerId'])
                              .get();

                          final work =
                              workSnapshot.data() as Map<String, dynamic>;

                          if (clientSnapshot.exists) {
                            final cli =
                                clientSnapshot.data() as Map<String, dynamic>;

                            final int collect = cli['collect'] -
                                int.parse(paymentCreditController.text);
                            final int debts = cli['debts'] - 1;
                            final int paidCliente = cli['paid'] + 1;
                            final int paidCobrador = work['paid'] + 1;

                            if (paymentCreditController.text == '') {
                              LoadingScreen().hide();
                              displayMessageToUser(
                                  'Debe agregar el abono del cliente', context);
                            } else {
                              if (loanAmount == 0) {
                                final int quota = data['quotaMax'] - 1;
                                final int loans = doc['loans'] - 1;
                                FirebaseFirestore.instance
                                    .collection('Prestamos+${_pref.uid}')
                                    .doc('General')
                                    .update({
                                  'balance': balance,
                                  'loans': loans,
                                  'collectAmount': collectAmount,
                                  'earnings': earnings,
                                  'paid': paidGeneral
                                });

                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(_pref.uid)
                                    .update({
                                  'balance': balance,
                                });

                                FirebaseFirestore.instance
                                    .collection('Prestamos+${_pref.uid}')
                                    .doc(id)
                                    .update({
                                  'loanAmount': loanAmount,
                                  'proxPay': newDateString,
                                  'quotaMax': quota,
                                  'paid': paidPrestamo
                                });

                                FirebaseFirestore.instance
                                    .collection('Clientes+${_pref.uid}')
                                    .doc(data['clientId'])
                                    .update({
                                  'collect': collect,
                                  'debts': debts,
                                  'paid': paidCliente
                                });

                                FirebaseFirestore.instance
                                    .collection('Cobradores+${_pref.uid}')
                                    .doc(data['workerId'])
                                    .update({
                                  'collect': collect,
                                  'debts': debts,
                                  'paid': paidCobrador,
                                });

                                FirebaseFirestore.instance
                                    .collection('Prestamos+${_pref.uid}')
                                    .doc(id)
                                    .collection('Historial')
                                    .doc()
                                    .set({
                                  'client': data['client'],
                                  'clientId': data['clientId'],
                                  'worker': data['worker'],
                                  'workerId': data['workerId'],
                                  'loanId': id,
                                  'amount': data['amount'],
                                  'address': data['address'],
                                  'email': data['email'],
                                  'phone': data['phone'],
                                  'cashPayment':
                                      int.parse(paymentCreditController.text),
                                  'totalDebt': collect,
                                  'proxPay': newDateString,
                                  'date': fcreate,
                                  'hour': hcreate,
                                });

                                final gananciasSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('Ganancias+${_pref.uid}')
                                        .doc(fcreate)
                                        .get();

                                if (gananciasSnapshot.exists) {
                                  final gan = gananciasSnapshot.data()
                                      as Map<String, dynamic>;

                                  final int ganancias = gan['profits'] +
                                      int.parse(paymentCreditController.text);

                                  FirebaseFirestore.instance
                                      .collection('Ganancias+${_pref.uid}')
                                      .doc(fcreate)
                                      .update({
                                    'profits': ganancias,
                                    'date': fcreate,
                                  });
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Ganancias+${_pref.uid}')
                                      .doc(fcreate)
                                      .update({
                                    'profits':
                                        int.parse(paymentCreditController.text),
                                    'date': fcreate,
                                  });
                                }
                              } else {
                                final int quota = data['quotaMax'] - 1;
                                FirebaseFirestore.instance
                                    .collection('Prestamos+${_pref.uid}')
                                    .doc('General')
                                    .update({
                                  'balance': balance,
                                  'collectAmount': collectAmount,
                                  'earnings': earnings,
                                  'paid': paidGeneral
                                });

                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(_pref.uid)
                                    .update({
                                  'balance': balance,
                                  'quotaMax': quota
                                });

                                FirebaseFirestore.instance
                                    .collection('Prestamos+${_pref.uid}')
                                    .doc(id)
                                    .update({
                                  'loanAmount': loanAmount,
                                  'proxPay': newDateString,
                                  'quotaMax': quota,
                                  'paid': paidPrestamo
                                });

                                FirebaseFirestore.instance
                                    .collection('Clientes+${_pref.uid}')
                                    .doc(data['clientId'])
                                    .update({
                                  'collect': collect,
                                  'paid': paidCliente
                                });

                                FirebaseFirestore.instance
                                    .collection('Cobradores+${_pref.uid}')
                                    .doc(data['workerId'])
                                    .update({
                                  'collect': collect,
                                  'paid': paidCobrador,
                                });

                                FirebaseFirestore.instance
                                    .collection('Prestamos+${_pref.uid}')
                                    .doc(id)
                                    .collection('Historial')
                                    .doc()
                                    .set({
                                  'client': data['client'],
                                  'clientId': data['clientId'],
                                  'worker': data['worker'],
                                  'workerId': data['workerId'],
                                  'loanId': id,
                                  'amount': cli['amount'],
                                  'cashPayment':
                                      int.parse(paymentCreditController.text),
                                  'totalDebt': collect,
                                  'proxPay': newDateString,
                                  'date': fcreate,
                                  'hour': hcreate,
                                });

                                final gananciasSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('Ganancias+${_pref.uid}')
                                        .doc(fcreate)
                                        .get();

                                if (gananciasSnapshot.exists) {
                                  final gan = gananciasSnapshot.data()
                                      as Map<String, dynamic>;

                                  final int ganancias = gan['profits'] +
                                      int.parse(paymentCreditController.text);

                                  FirebaseFirestore.instance
                                      .collection('Ganancias+${_pref.uid}')
                                      .doc(fcreate)
                                      .update({
                                    'profits': ganancias,
                                    'date': fcreate,
                                  });
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Ganancias+${_pref.uid}')
                                      .doc(fcreate)
                                      .update({
                                    'profits':
                                        int.parse(paymentCreditController.text),
                                    'date': fcreate,
                                  });
                                }
                              }
                            }
                            displayMessageToUser('Datos Guardados', context);
                            paymentCreditController.clear();
                            LoadingScreen().hide();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            LoadingScreen().hide();
                            displayMessageToUser(
                                'El cliente no existe', context);
                          }
                        } else {
                          LoadingScreen().hide();
                          displayMessageToUser(
                              'El documento general no existe', context);
                        }
                      } else {
                        LoadingScreen().hide();
                        displayMessageToUser(
                            'El abono debe ser igual o mayor que de ${data['quotaNumber']}',
                            context);
                      }
                    },
                    child: Text('Guardar',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColor.white().color
                                    : MyColor.black().color)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  void not_payment_credit(id) async {
    LoadingScreen().show(context);

    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Prestamos+${_pref.uid}')
        .doc(id)
        .get();

    final data = documentSnapshot.data() as Map<String, dynamic>;

    final now = DateTime.now();
    final hcreate = DateFormat('HH:mm:ss').format(now);
    final fcreate = DateFormat('yyyy-MM-dd').format(now);

    DateTime calculateNewDate(DateTime today, String tipePay) {
      DateTime newDate;
      switch (tipePay) {
        case 'Diario':
          newDate = today.add(Duration(days: 1));
          break;
        case 'Semanal':
          newDate = today.add(Duration(days: 7));
          break;
        case 'Mensual':
          newDate = today.add(Duration(days: 30));
          break;
        case 'Bimestral':
          newDate = today.add(Duration(days: 60));
          break;
        case 'Trimestral':
          newDate = today.add(Duration(days: 90));
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

    final int unpaidPrestamo = data['unpaid'] + 1;

    String calculateNewDateString(DateTime today, String tipePay) {
      DateTime newDate = calculateNewDate(today, tipePay);
      return DateFormat('yyyy-MM-dd').format(newDate);
    }

    String tipePay = data['tipePay'];
    String newDateString = calculateNewDateString(now, tipePay);

    final int loanAmount = data['loanAmount'] - 0;

    final generalSnapshot = await FirebaseFirestore.instance
        .collection('Prestamos+${_pref.uid}')
        .doc('General')
        .get();

    if (generalSnapshot.exists) {
      final doc = generalSnapshot.data() as Map<String, dynamic>;

      final int unpaidGeneral = doc['unpaid'] + 1;

      final int collectAmount = doc['collectAmount'] - 0;
      final int earnings = doc['earnings'] + 0;

      final clientSnapshot = await FirebaseFirestore.instance
          .collection('Clientes+${_pref.uid}')
          .doc(data['clientId'])
          .get();

      final workSnapshot = await FirebaseFirestore.instance
          .collection('Cobradores+${_pref.uid}')
          .doc(data['workerId'])
          .get();

      final work = workSnapshot.data() as Map<String, dynamic>;

      if (clientSnapshot.exists) {
        final cli = clientSnapshot.data() as Map<String, dynamic>;

        final int collect = cli['collect'] - 0;
        final int debts = cli['debts'] - 1;
        final int unpaidCliente = cli['unpaid'] + 1;
        final int unpaidCobrador = work['unpaid'] + 1;

        if (loanAmount == 0) {
          final int loans = doc['loans'] - 1;
          final int quota = data['quotaMax'] - 1;
          FirebaseFirestore.instance
              .collection('Prestamos+${_pref.uid}')
              .doc('General')
              .update({
            'loans': loans,
            'collectAmount': collectAmount,
            'earnings': earnings,
            'unpaid': unpaidGeneral
          });

          FirebaseFirestore.instance
              .collection('Prestamos+${_pref.uid}')
              .doc(id)
              .update({
            'loanAmount': loanAmount,
            'proxPay': newDateString,
            'quotaMax': quota,
            'unpaid': unpaidPrestamo
          });

          FirebaseFirestore.instance
              .collection('Clientes+${_pref.uid}')
              .doc(data['clientId'])
              .update({
            'collect': collect,
            'debts': debts,
            'unpaid': unpaidCliente
          });

          FirebaseFirestore.instance
              .collection('Cobradores+${_pref.uid}')
              .doc(data['workerId'])
              .update({
            'collect': collect,
            'debts': debts,
            'unpaid': unpaidCobrador,
          });

          FirebaseFirestore.instance
              .collection('Prestamos+${_pref.uid}')
              .doc(id)
              .collection('Historial')
              .doc()
              .set({
            'client': data['client'],
            'clientId': data['clientId'],
            'worker': data['worker'],
            'workerId': data['workerId'],
            'loanId': id,
            'amount': data['amount'],
            'address': data['address'],
            'email': data['email'],
            'phone': data['phone'],
            'cashPayment': 0,
            'totalDebt': collect,
            'proxPay': newDateString,
            'date': fcreate,
            'hour': hcreate,
          });
        } else {
          final int quota = data['quotaMax'] - 1;
          FirebaseFirestore.instance
              .collection('Prestamos+${_pref.uid}')
              .doc('General')
              .update({
            'collectAmount': collectAmount,
            'earnings': earnings,
            'unpaid': unpaidGeneral
          });

          FirebaseFirestore.instance
              .collection('Users')
              .doc(_pref.uid)
              .update({'quotaMax': quota});

          FirebaseFirestore.instance
              .collection('Prestamos+${_pref.uid}')
              .doc(id)
              .update({
            'loanAmount': loanAmount,
            'proxPay': newDateString,
            'quotaMax': quota,
            'unpaid': unpaidPrestamo
          });

          FirebaseFirestore.instance
              .collection('Clientes+${_pref.uid}')
              .doc(data['clientId'])
              .update({'collect': collect, 'unpaid': unpaidCliente});

          FirebaseFirestore.instance
              .collection('Cobradores+${_pref.uid}')
              .doc(data['workerId'])
              .update({
            'collect': collect,
            'unpaid': unpaidCobrador,
          });

          FirebaseFirestore.instance
              .collection('Prestamos+${_pref.uid}')
              .doc(id)
              .collection('Historial')
              .doc()
              .set({
            'client': data['client'],
            'clientId': data['clientId'],
            'worker': data['worker'],
            'workerId': data['workerId'],
            'loanId': id,
            'amount': cli['amount'],
            'cashPayment': 0,
            'totalDebt': collect,
            'proxPay': newDateString,
            'date': fcreate,
            'hour': hcreate,
          });
        }
        displayMessageToUser('Datos Guardados', context);
        paymentCreditController.clear();
        LoadingScreen().hide();
      } else {
        LoadingScreen().hide();
        displayMessageToUser('El cliente no existe', context);
      }
    } else {
      LoadingScreen().hide();
      displayMessageToUser('El documento general no existe', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Center(child: Text('P r e s t a m o s')),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, NewLoan.routname);
              },
              tooltip: 'Add',
              alignment: Alignment.center,
            ),
          ],
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? MyColor.grannySmith().color
              : MyColor.capeCod().color,
        ),
        drawer: const MyDrawer(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Prestamos+${_pref.uid}')
                  .doc('General')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data?.exists == false) {
                  return const Text('Document does not exist');
                }

                final DocumentSnapshot<dynamic>? document = snapshot.data;
                final data = document?.data();

                if (data == null) {
                  return const Text('No data');
                }

                final int earnings = data['earnings'] - data['loanAmounts'];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).brightness == Brightness.light
                          ? MyColor.manatee().color
                          : MyColor.abbey().color,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Saldo Disponible: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'es', symbol: '\$')
                                      .format(data['balance']),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 10, // The height of the divider
                            thickness: 1, // The thickness of the divider
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColor.black().color
                                    : MyColor.iron().color,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nº Prestamos Pendientes: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                                Text(
                                  data['loans'].toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 10, // The height of the divider
                            thickness: 1, // The thickness of the divider
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColor.black().color
                                    : MyColor.iron().color,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monto por Cobrar: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'es', symbol: '\$')
                                      .format(data['collectAmount']),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 10, // The height of the divider
                            thickness: 1, // The thickness of the divider
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColor.black().color
                                    : MyColor.iron().color,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monto Prestado: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'es', symbol: '\$')
                                      .format(data['loanAmounts']),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 10,
                            thickness: 1,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColor.black().color
                                    : MyColor.iron().color,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ganancias: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.iron().color,
                                  ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'es', symbol: '\$')
                                      .format(earnings),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: earnings < 0
                                        ? Colors.red
                                        : Theme.of(context).brightness ==
                                                Brightness.light
                                            ? MyColor.black().color
                                            : MyColor.iron().color,
                                    fontWeight: earnings < 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Prestamos+${_pref.uid}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Stack(
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              'No hay Datos',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final service = snapshot.data?.docs;

                  if (service == null) {
                    return const Text('No data');
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: service.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = service[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String docID = document.id;

                        final now = DateTime.now();
                        final fhoy = DateFormat('yyyy-MM-dd').format(now);

                        if (fhoy == data['proxPay']) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                            child: Container(
                              width: MediaQuery.of(context).size.height * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? MyColor.manatee().color
                                    : MyColor.abbey().color,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  data['client'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 27,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? MyColor.black().color
                                                        : MyColor.iron().color,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 10,
                                          thickness: 1,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? MyColor.black().color
                                              : MyColor.iron().color,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Dinero por Cobrar: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                        Text(
                                                          NumberFormat.currency(
                                                                  locale: 'es',
                                                                  symbol: '\$')
                                                              .format(data[
                                                                  'loanAmount']),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'Pago por Cuota: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        Text(
                                                          NumberFormat.currency(
                                                                  locale: 'es',
                                                                  symbol: '\$')
                                                              .format(data[
                                                                  'quotaNumber']),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Numero de Cuotas: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                        Text(
                                                          data['quotaMax']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Porcentaje: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${data['percentage']}%',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Abonos Pagados: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${data['paid'].toString()}',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Abonos en Mora: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${data['unpaid'].toString()}',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? MyColor
                                                                        .black()
                                                                    .color
                                                                : MyColor.iron()
                                                                    .color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.check),
                                                  onPressed: () {
                                                    new_payment_credit(docID);
                                                  },
                                                  iconSize: 35,
                                                  tooltip: 'Abono',
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                  alignment: Alignment.center,
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    not_payment_credit(docID);
                                                  },
                                                  iconSize: 35,
                                                  tooltip: 'Abono',
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                  alignment: Alignment.center,
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.list_sharp),
                                                  onPressed: () {
                                                    view_history(docID);
                                                  },
                                                  iconSize: 35,
                                                  tooltip: 'Histrial',
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? MyColor.black().color
                                                      : MyColor.iron().color,
                                                  alignment: Alignment.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  );
                })
          ],
        ));
  }
}
