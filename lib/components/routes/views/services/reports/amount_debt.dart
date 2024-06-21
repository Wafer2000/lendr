import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/views/services/reports/AmountDebt/amount_debt_annual.dart';
import 'package:lendr/components/routes/views/services/reports/AmountDebt/amount_debt_bimonthly.dart';
import 'package:lendr/components/routes/views/services/reports/AmountDebt/amount_debt_daily.dart';
import 'package:lendr/components/routes/views/services/reports/AmountDebt/amount_debt_monthly.dart';
import 'package:lendr/components/routes/views/services/reports/AmountDebt/amount_debt_quarterly.dart';
import 'package:lendr/components/routes/views/services/reports/AmountDebt/amount_debt_semiannual.dart';
import 'package:lendr/components/routes/views/services/reports/AmountDebt/amount_debt_weekly.dart';
import 'package:lendr/style/global_colors.dart';

class AmountDebt extends StatefulWidget {
  static const String routname = '/amount_debt';
  const AmountDebt({super.key});

  @override
  State<AmountDebt> createState() => _AmountDebtState();
}

class _AmountDebtState extends State<AmountDebt> {
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screens = [
      const AmountDebtDaily(),
      const AmountDebtWeekly(),
      const AmountDebtMonthly(),
      const AmountDebtBimonthly(),
      const AmountDebtQuarterly(),
      const AmountDebtSemiannual(),
      const AmountDebtAnnual()
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Información Detallada de Deudas')),
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