import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/views/services/reports/RealiabilityClients/realiability_clients_annual.dart';
import 'package:lendr/components/routes/views/services/reports/RealiabilityClients/realiability_clients_bimonthly.dart';
import 'package:lendr/components/routes/views/services/reports/RealiabilityClients/realiability_clients_daily.dart';
import 'package:lendr/components/routes/views/services/reports/RealiabilityClients/realiability_clients_monthly.dart';
import 'package:lendr/components/routes/views/services/reports/RealiabilityClients/realiability_clients_quarterly.dart';
import 'package:lendr/components/routes/views/services/reports/RealiabilityClients/realiability_clients_semiannual.dart';
import 'package:lendr/components/routes/views/services/reports/RealiabilityClients/realiability_clients_weekly.dart';
import 'package:lendr/style/global_colors.dart';

class ReliabilityClients extends StatefulWidget {
  static const String routname = '/reliability_clients';
  const ReliabilityClients({super.key});

  @override
  State<ReliabilityClients> createState() => _ReliabilityClientsState();
}

class _ReliabilityClientsState extends State<ReliabilityClients> {
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screens = [
      const ReliabilityClientsDaily(),
      const ReliabilityClientsWeekly(),
      const ReliabilityClientsMonthly(),
      const ReliabilityClientsBimonthly(),
      const ReliabilityClientsQuarterly(),
      const ReliabilityClientsSemiannual(),
      const ReliabilityClientsAnnual()
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Confiabilidad de Clientes')),
        actions: const [
            SizedBox(
              width: 56,
            ),
          ],
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? MyColor.grannySmith().color
            : MyColor.capeCod().color,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FadeIn(
        child: IndexedStack(
          index: selectedIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? MyColor.grannySmith().color
            : MyColor.capeCod().color,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Diario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Semanal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Mensual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Bimestral',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Trimestral',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Semestral',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Anual',
          ),
        ],
      ),
    );
  }
}