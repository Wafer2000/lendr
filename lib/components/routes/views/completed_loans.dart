import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendr/components/routes/tools/my_drawer.dart';
import 'package:lendr/components/routes/views/services/new_loan.dart';
import 'package:lendr/shared/prefe_users.dart';
import 'package:lendr/style/global_colors.dart';

class CompletedLoans extends StatefulWidget {
  static const String routname = '/completed_loans';
  const CompletedLoans({super.key});

  @override
  State<CompletedLoans> createState() => _CompletedLoansState();
}

class _CompletedLoansState extends State<CompletedLoans> {
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
                                            '${data['amount']}',
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
                                            '${data['cashPayment']}',
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
                                                : '${data['totalDebt']}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Center(child: Text('C o b r o s  C o m p l e t a d o s')),
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
                    .where('state', isEqualTo: true)
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
                                                          data['quotaMax'].toString(),
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
