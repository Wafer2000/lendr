import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/views/services/reports/EarningsPerCollector/earnings_per_collector_annual.dart';
import 'package:lendr/components/routes/views/services/reports/EarningsPerCollector/earnings_per_collector_bimonthly.dart';
import 'package:lendr/components/routes/views/services/reports/EarningsPerCollector/earnings_per_collector_daily.dart';
import 'package:lendr/components/routes/views/services/reports/EarningsPerCollector/earnings_per_collector_monthly.dart';
import 'package:lendr/components/routes/views/services/reports/EarningsPerCollector/earnings_per_collector_quarterly.dart';
import 'package:lendr/components/routes/views/services/reports/EarningsPerCollector/earnings_per_collector_semiannual.dart';
import 'package:lendr/components/routes/views/services/reports/EarningsPerCollector/earnings_per_collector_weekly.dart';
import 'package:lendr/style/global_colors.dart';

class EarningsPerCollector extends StatefulWidget {
  static const String routname = '/earnings_per_collector';
  const EarningsPerCollector({super.key});

  @override
  State<EarningsPerCollector> createState() => _EarningsPerCollectorState();
}

class _EarningsPerCollectorState extends State<EarningsPerCollector> {
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screens = [
      const EarningsPerCollectorDaily(),
      const EarningsPerCollectorWeekly(),
      const EarningsPerCollectorMonthly(),
      const EarningsPerCollectorBimonthly(),
      const EarningsPerCollectorQuarterly(),
      const EarningsPerCollectorSemiannual(),
      const EarningsPerCollectorAnnual()
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Ganancias por Cobrador')),
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