import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendr/tools/my_drawer.dart';
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
          return Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Prestamos')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title:
              const Center(child: Text('C o b r o s  C o m p l e t a d o s')),
          actions: const [
            SizedBox(
              width: 56,
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
                  .collection('Prestamos')
                  .doc('General${_pref.uid}')
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
                    .collection('Prestamos')
                    .where('user', isEqualTo: _pref.uid)
                    .where('state', isEqualTo: false)
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
