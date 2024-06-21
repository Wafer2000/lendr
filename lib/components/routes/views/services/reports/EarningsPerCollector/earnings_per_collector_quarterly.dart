import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lendr/shared/prefe_users.dart';

class EarningsPerCollectorQuarterly extends StatefulWidget {
  static const String routname = '/earnings_per_collector_quarterly';
  const EarningsPerCollectorQuarterly({super.key});

  @override
  State<EarningsPerCollectorQuarterly> createState() => _EarningsPerCollectorQuarterlyState();
}

class _EarningsPerCollectorQuarterlyState extends State<EarningsPerCollectorQuarterly> {
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
                    .orderBy('diff', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
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
                                  'Primer Nombre',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Segundo Nombre',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Primer Apellido',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Segundo Apellido',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Cantidad de Ganancias',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            rows: service.asMap().entries.map((entry) {
                              Map<String, dynamic> data =
                                  entry.value.data() as Map<String, dynamic>;
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('${entry.key + 1}')),
                                  DataCell(Text('${data['firstname']}')),
                                  DataCell(Text('${data['middlename']}')),
                                  DataCell(Text('${data['lastname']}')),
                                  DataCell(Text('${data['secondlastname']}')),
                                  DataCell(Text('${data['diff']}')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ));
  }
}