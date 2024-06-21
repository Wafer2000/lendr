import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lendr/shared/prefe_users.dart';

class CollectorsLoanDaily extends StatefulWidget {
  static const String routname = '/collectors_loan_daily';
  const CollectorsLoanDaily({super.key});

  @override
  State<CollectorsLoanDaily> createState() => _CollectorsLoanDailyState();
}

class _CollectorsLoanDailyState extends State<CollectorsLoanDaily> {
  final _pref = PreferencesUser();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Cobradores')
                    .where('lendr', isEqualTo: _pref.uid)
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

                  final service1 = snapshot.data?.docs;

                  if (service1 == null) {
                    return const Text('No data');
                  }

                  return Expanded(
                    child: ListView.builder(
                        itemCount: service1.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document1 = service1[index];
                          Map<String, dynamic> data1 =
                              document1.data() as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Prestamos')
                                    .where('lendr', isEqualTo: _pref.uid)
                                    .where('workerId',
                                        isEqualTo: data1['workerId'])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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

                                  final service2 = snapshot.data?.docs;

                                  if (service2 == null) {
                                    return const Text('No data');
                                  }

                                  return Expanded(
                                    child: Column(
                                      children: [
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
                                                  'Cobrador',
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
                                                  'Nº Cuotas Faltantes',
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Nº Cuotas No Pagadas',
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Dinero por Cobrar',
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Ganancia Total al Culminar',
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            rows: service2
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              Map<String, dynamic> data2 =
                                                  entry.value.data()
                                                      as Map<String, dynamic>;
                                              return DataRow(
                                                cells: <DataCell>[
                                                  DataCell(
                                                      Text('${entry.key + 1}')),
                                                  DataCell(Text(
                                                      '${data2['worker']}')),
                                                  DataCell(Text(
                                                      '${data2['client']}')),
                                                  DataCell(Text(
                                                      '${data2['quotaMax']}')),
                                                  DataCell(Text(
                                                      '${data2['unpaid']}')),
                                                  DataCell(Text(
                                                      '${(data2['loanAmount']).toStringAsFixed(0)}')),
                                                  DataCell(Text(
                                                      '${((data2['paid'] + data2['unpaid'] + data2['quotaMax']) * data2['quotaNumber']).toStringAsFixed(0)}')),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          );
                        }),
                  );
                })
          ],
        ));
  }
}
