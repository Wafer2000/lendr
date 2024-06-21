import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lendr/components/routes/views/services/reports/CollectorsLoan/collectors_loan_annual.dart';
import 'package:lendr/components/routes/views/services/reports/CollectorsLoan/collectors_loan_bimonthly.dart';
import 'package:lendr/components/routes/views/services/reports/CollectorsLoan/collectors_loan_daily.dart';
import 'package:lendr/components/routes/views/services/reports/CollectorsLoan/collectors_loan_monthly.dart';
import 'package:lendr/components/routes/views/services/reports/CollectorsLoan/collectors_loan_quarterly.dart';
import 'package:lendr/components/routes/views/services/reports/CollectorsLoan/collectors_loan_semiannual.dart';
import 'package:lendr/components/routes/views/services/reports/CollectorsLoan/collectors_loan_weekly.dart';
import 'package:lendr/style/global_colors.dart';

class CollectorsLoan extends StatefulWidget {
  static const String routname = '/collector_loan';
  const CollectorsLoan({super.key});

  @override
  State<CollectorsLoan> createState() => _CollectorsLoanState();
}

class _CollectorsLoanState extends State<CollectorsLoan> {
  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screens = [
      const CollectorsLoanDaily(),
      const CollectorsLoanWeekly(),
      const CollectorsLoanMonthly(),
      const CollectorsLoanBimonthly(),
      const CollectorsLoanQuarterly(),
      const CollectorsLoanSemiannual(),
      const CollectorsLoanAnnual()
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('Reporte de Deudas y Ganancias')),
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