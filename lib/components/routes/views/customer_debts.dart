// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendr/tools/helper_functions.dart';
import 'package:lendr/tools/loading_indicator.dart';
import 'package:lendr/tools/my_textfield.dart';
import 'package:lendr/shared/prefe_users.dart';
import 'package:lendr/style/global_colors.dart';

class CustomerDebts extends StatefulWidget {
  static const String routname = '/customers_debts';
  const CustomerDebts({super.key});

  @override
  State<CustomerDebts> createState() => _CustomerDebtsState();
}

class _CustomerDebtsState extends State<CustomerDebts> {
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
          return AlertDialog(
            title: const Text(
              'Historial',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            icon: Icon(
              Icons.list,
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: StreamBuilder<QuerySnapshot>(
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
                    body: ListView.builder(
                      itemCount: service?.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = service![index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Text(
                                          'Cliente: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign:
                                              TextAlign.left, // Add this line
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${data['client']}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                            textAlign:
                                                TextAlign.left, // Add this line
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Text(
                                          'Prestamo: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign:
                                              TextAlign.left, // Add this line
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Flexible(
                                          child: Text(
                                            NumberFormat.currency(
                                                    locale: 'es', symbol: '\$')
                                                .format(data['amount']),
                                            style:
                                                const TextStyle(fontSize: 15),
                                            textAlign:
                                                TextAlign.left, // Add this line
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Text(
                                          'Abono: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign:
                                              TextAlign.left, // Add this line
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Flexible(
                                          child: Text(
                                            NumberFormat.currency(
                                                    locale: 'es', symbol: '\$')
                                                .format(data['cashPayment']),
                                            style:
                                                const TextStyle(fontSize: 15),
                                            textAlign:
                                                TextAlign.left, // Add this line
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Text(
                                          'Deuda Faltante: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign:
                                              TextAlign.left, // Add this line
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Flexible(
                                          child: Text(
                                            data['totalDebt'] <= 0
                                                ? '0'
                                                : NumberFormat.currency(
                                                        locale: 'es',
                                                        symbol: '\$')
                                                    .format(data['totalDebt']),
                                            style:
                                                const TextStyle(fontSize: 15),
                                            textAlign:
                                                TextAlign.left, // Add this line
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Text(
                                          'Proximo Cobro: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign:
                                              TextAlign.left, // Add this line
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize:
                                          MainAxisSize.min, // Add this line
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${data['proxPay']}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                            textAlign:
                                                TextAlign.left, // Add this line
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 10, // The height of the divider
                                    thickness:
                                        1, // The thickness of the divider
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? MyColor.black().color
                                        : MyColor.white()
                                            .color, // The color of the divider
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Hora de Abono: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        '${data['hour']}',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fecha de Abono: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        '${data['date']}',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
                  MyTextField(
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
                            newDate = today.add(const Duration(days: 1));
                            break;
                          case 'Semanal':
                            newDate = today.add(const Duration(days: 7));
                            break;
                          case 'Quincenal':
                            newDate = today.add(const Duration(days: 15));
                            break;
                          case 'Mensual':
                            newDate = today.add(const Duration(days: 30));
                            break;
                          case 'Semestral':
                            newDate = today.add(const Duration(days: 180));
                            break;
                          case 'Anual':
                            newDate = today.add(const Duration(days: 365));
                            break;
                          default:
                            newDate = today;
                            break;
                        }
                        return newDate;
                      }

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

                      if (generalSnapshot.exists) {
                        final doc =
                            generalSnapshot.data() as Map<String, dynamic>;

                        final int collectAmount = doc['collectAmount'] -
                            int.parse(paymentCreditController.text);
                        final int earnings = doc['earnings'] +
                            int.parse(paymentCreditController.text);

                        final clientSnapshot = await FirebaseFirestore.instance
                            .collection('Clientes+${_pref.uid}')
                            .doc(data['clientId'])
                            .get();

                        if (clientSnapshot.exists) {
                          final cli =
                              clientSnapshot.data() as Map<String, dynamic>;

                          final int collect = cli['collect'] -
                              int.parse(paymentCreditController.text);
                          final int debts = cli['debts'] - 1;

                          if (paymentCreditController.text == '') {
                            LoadingScreen().hide();
                            displayMessageToUser(
                                'Debe agregar el abono del cliente', context);
                          } else {
                            if (loanAmount == 0) {
                              final int loans = doc['loans'] - 1;
                              FirebaseFirestore.instance
                                  .collection('Prestamos+${_pref.uid}')
                                  .doc('General')
                                  .update({
                                'loans': loans,
                                'collectAmount': collectAmount,
                                'earnings': earnings
                              });

                              FirebaseFirestore.instance
                                  .collection('Prestamos+${_pref.uid}')
                                  .doc(id)
                                  .update({
                                'loanAmount': loanAmount,
                                'proxPay': newDateString,
                                'state': true
                              });

                              FirebaseFirestore.instance
                                  .collection('Clientes+${_pref.uid}')
                                  .doc(data['clientId'])
                                  .update({'collect': collect, 'debts': debts});

                              FirebaseFirestore.instance
                                  .collection('Prestamos+${_pref.uid}')
                                  .doc(id)
                                  .collection('Historial')
                                  .doc()
                                  .set({
                                'client': data['client'],
                                'clientId': data['clientId'],
                                'loanId': id,
                                'amount': data['amount'],
                                'cashPayment':
                                    int.parse(paymentCreditController.text),
                                'totalDebt': collect,
                                'proxPay': newDateString,
                                'date': fcreate,
                                'hour': hcreate,
                              });
                            } else {
                              FirebaseFirestore.instance
                                  .collection('Prestamos+${_pref.uid}')
                                  .doc('General')
                                  .update({
                                'collectAmount': collectAmount,
                                'earnings': earnings
                              });

                              FirebaseFirestore.instance
                                  .collection('Prestamos+${_pref.uid}')
                                  .doc(id)
                                  .update({
                                'loanAmount': loanAmount,
                                'proxPay': newDateString
                              });

                              FirebaseFirestore.instance
                                  .collection('Clientes+${_pref.uid}')
                                  .doc(data['clientId'])
                                  .update({
                                'collect': collect,
                              });

                              FirebaseFirestore.instance
                                  .collection('Prestamos+${_pref.uid}')
                                  .doc(id)
                                  .collection('Historial')
                                  .doc()
                                  .set({
                                'client': data['client'],
                                'clientId': data['clientId'],
                                'loanId': id,
                                'amount': cli['amount'],
                                'cashPayment':
                                    int.parse(paymentCreditController.text),
                                'totalDebt': collect,
                                'proxPay': newDateString,
                                'date': fcreate,
                                'hour': hcreate,
                              });
                            }
                          }
                          displayMessageToUser('Datos Guardados', context);
                          paymentCreditController.clear();
                          LoadingScreen().hide();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          LoadingScreen().hide();
                          displayMessageToUser('El cliente no existe', context);
                        }
                      } else {
                        LoadingScreen().hide();
                        displayMessageToUser(
                            'El documento general no existe', context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('P r e s t a m o s   d e l   C l i e n t e'),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? MyColor.grannySmith().color
              : MyColor.capeCod().color,
          actions: const [
            SizedBox(
              width: 56,
            )
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Prestamos+${_pref.uid}')
                    .where('clientId', isEqualTo: _pref.loanId)
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

                        if (fhoy != data['proxPay']) {
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
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.monetization_on),
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
                                                const SizedBox(
                                                  width: 10,
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
                                        ),
                                        Divider(
                                          height: 10,
                                          thickness: 1,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? MyColor.black().color
                                              : MyColor.iron().color,
                                        ),
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
                                                  data['state'] == true
                                                      ? 'PAGO COMPLETADO'
                                                      : 'PAGO NO COMPLETADO',
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
