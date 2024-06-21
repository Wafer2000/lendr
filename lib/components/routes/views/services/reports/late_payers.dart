import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/views/services/reports/LatePayers/late_payers_annual.dart';
import 'package:lendr/components/routes/views/services/reports/LatePayers/late_payers_bimonthly.dart';
import 'package:lendr/components/routes/views/services/reports/LatePayers/late_payers_daily.dart';
import 'package:lendr/components/routes/views/services/reports/LatePayers/late_payers_monthly.dart';
import 'package:lendr/components/routes/views/services/reports/LatePayers/late_payers_quarterly.dart';
import 'package:lendr/components/routes/views/services/reports/LatePayers/late_payers_semiannual.dart';
import 'package:lendr/components/routes/views/services/reports/LatePayers/late_payers_weekly.dart';
import 'package:lendr/style/global_colors.dart';

class LatePayers extends StatefulWidget {
  static const String routname = '/late_payers';
  const LatePayers({super.key});

  @override
  State<LatePayers> createState() => _LatePayersState();
}

class _LatePayersState extends State<LatePayers> {
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screens = [
      const LatePayersDaily(),
      const LatePayersWeekly(),
      const LatePayersMonthly(),
      const LatePayersBimonthly(),
      const LatePayersQuarterly(),
      const LatePayersSemiannual(),
      const LatePayersAnnual()
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Clientes que no Pagaron')),
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