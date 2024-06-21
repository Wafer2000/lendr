import 'package:flutter/material.dart';
import 'package:lendr/components/routes/views/services/reports/amount_debt.dart';
import 'package:lendr/components/routes/views/services/reports/collectors_loan.dart';
import 'package:lendr/components/routes/views/services/reports/earnings_per_collector.dart';
import 'package:lendr/components/routes/views/services/reports/late_payers.dart';
import 'package:lendr/components/routes/views/services/reports/reliability_clients.dart';
import 'package:lendr/style/global_colors.dart';
import 'package:lendr/tools/my_drawer.dart';

class Reports extends StatefulWidget {
  static const String routname = '/reports';
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('R E P O R T E S')),
        actions: const [
          SizedBox(
            width: 56,
          ),
        ],
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? MyColor.grannySmith().color
            : MyColor.capeCod().color,
      ),
      drawer: MyDrawer(),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    height: MediaQuery.sizeOf(context).width * 0.45,
                    child: FloatingActionButton.extended(
                      heroTag: 'amountdebtTag',
                      onPressed: () {
                        Navigator.pushNamed(context, AmountDebt.routname);
                      },
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                            size: 35,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Información',
                            style: TextStyle(fontSize: 18),
                          ),
                          const Text(
                            'Detallada de Deudas',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? MyColor.abbey().color
                              : MyColor.grannySmith().color,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    height: MediaQuery.sizeOf(context).width * 0.45,
                    child: FloatingActionButton.extended(
                      heroTag: 'collectorsloanTag',
                      onPressed: () {
                        Navigator.pushNamed(context, CollectorsLoan.routname);
                      },
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_chart,
                            color: Theme.of(context).colorScheme.primary,
                            size: 35,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Reporte de',
                            style: TextStyle(fontSize: 18),
                          ),
                          const Text(
                            'Deudas y Ganancias',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? MyColor.abbey().color
                              : MyColor.grannySmith().color,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    height: MediaQuery.sizeOf(context).width * 0.45,
                    child: FloatingActionButton.extended(
                      heroTag: 'earningspercollectorTag',
                      onPressed: () {
                        Navigator.pushNamed(
                            context, EarningsPerCollector.routname);
                      },
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Theme.of(context).colorScheme.primary,
                            size: 35,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Ganancias por',
                            style: TextStyle(fontSize: 18),
                          ),
                          const Text(
                            'Cobrador',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? MyColor.abbey().color
                              : MyColor.grannySmith().color,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    height: MediaQuery.sizeOf(context).width * 0.45,
                    child: FloatingActionButton.extended(
                      heroTag: 'latepayersTag',
                      onPressed: () {
                        Navigator.pushNamed(context, LatePayers.routname);
                      },
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning,
                            color: Theme.of(context).colorScheme.primary,
                            size: 35,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Clientes que',
                            style: TextStyle(fontSize: 18),
                          ),
                          const Text(
                            'No Pagaron',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? MyColor.abbey().color
                              : MyColor.grannySmith().color,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    height: MediaQuery.sizeOf(context).width * 0.45,
                    child: FloatingActionButton.extended(
                      heroTag: 'reliabilityclientsTag',
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ReliabilityClients.routname);
                      },
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: Theme.of(context).colorScheme.primary,
                            size: 35,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Confiabilidad de',
                            style: TextStyle(fontSize: 18),
                          ),
                          const Text(
                            'Clientes',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? MyColor.abbey().color
                              : MyColor.grannySmith().color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
