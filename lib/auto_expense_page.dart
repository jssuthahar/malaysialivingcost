import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';

class AutoExpensePage extends StatefulWidget {
  const AutoExpensePage({super.key});

  @override
  State<AutoExpensePage> createState() => _AutoExpensePageState();
}

class _AutoExpensePageState extends State<AutoExpensePage> {
  String _selectedFamilyType = "Single";
  double monthlyIncome = 5000;

  /// Default expenses based on family type
  final Map<String, Map<String, double>> defaultExpenses = {
    "Single": {
      "Rent": 1200,
      "Water Bill": 20,
      "Electricity Bill": 100,
      "Internet Bill":

          /// In the `_AutoExpensePageState` class, the number `120` is used as a default
          /// value for the "Water Bill" expense in the expense breakdown for the different
          /// family types.
          120,
      "Mobile Bill": 40,
      "Groceries": 200,
      "Gas Cylinder": 30,
      "Vegetables": 200,
      "Fruits": 200,
      "Eating Out": 0,
      "Drinking": 0,
      "Smoking": 0,
      "Entertainment": 0,
      "Weekly Outing": 0,
      "Temple Donation": 0,
      "Transport": 200,
      "Medical": 100,
      "Clinic Visits": 80,
      "Netflix": 0,
      "Amazon Prime": 0,
      "TV Channels": 0,
      "Other": 100,
    },
    "Married": {
      "Rent": 2000,
      "Water Bill": 20,
      "Electricity Bill": 100,
      "Internet Bill": 150,
      "Mobile Bill": 80,
      "Groceries": 800,
      "Gas Cylinder": 30,
      "Vegetables": 400,
      "Fruits": 400,
      "Eating Out": 500,
      "Drinking": 0,
      "Smoking": 0,
      "Entertainment": 0,
      "Weekly Outing": 300,
      "Temple Donation": 0,
      "Transport": 0,
      "Medical": 200,
      "Clinic Visits": 150,
      "Netflix": 0,
      "Amazon Prime": 0,
      "TV Channels": 0,
      "Other": 200,
    },
    "Married + 1 Kid": {
      "Rent": 2200,
      "Water Bill": 50,
      "Electricity Bill": 200,
      "Internet Bill": 150,
      "Mobile Bill": 80,
      "Groceries": 800,
      "Gas Cylinder": 30,
      "Vegetables": 400,
      "Fruits": 400,
      "Eating Out": 700,
      "Drinking": 0,
      "Smoking": 0,
      "Entertainment": 600,
      "Weekly Outing": 350,
      "Temple Donation": 150,
      "Transport": 500,
      "Child Education": 800,
      "Medical": 300,
      "Clinic Visits": 200,
      "Netflix": 0,
      "Amazon Prime": 0,
      "TV Channels": 0,
      "Other": 300,
    },
    "Married + 2 Kids": {
      "Rent": 2500,
      "Water Bill": 50,
      "Electricity Bill": 200,
      "Internet Bill": 200,
      "Mobile Bill": 80,
      "Groceries": 800,
      "Gas Cylinder": 30,
      "Vegetables": 800,
      "Fruits": 600,
      "Eating Out": 600,
      "Drinking": 0,
      "Smoking": 0,
      "Entertainment": 400,
      "Weekly Outing": 400,
      "Temple Donation": 0,
      "Transport": 700,
      "Child Education": 1500,
      "Medical": 400,
      "Clinic Visits": 300,
      "Netflix": 0,
      "Amazon Prime": 0,
      "TV Channels": 0,
      "Other": 400,
    }
  };

  late Map<String, double> currentExpenses;

  @override
  void initState() {
    super.initState();
    currentExpenses = Map.from(defaultExpenses[_selectedFamilyType]!);
  }

  double get totalExpenses => currentExpenses.values.fold(0, (a, b) => a + b);

  double get monthlySavings => monthlyIncome - totalExpenses;

  double get yearlySavings => monthlySavings * 12;

  void _updateFamilyType(String type) {
    setState(() {
      _selectedFamilyType = type;
      currentExpenses = Map.from(defaultExpenses[type]!);
    });
  }

  Future<void> _exportToPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Malaysia Living Cost Report",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("Family Type: $_selectedFamilyType"),
              pw.Text("Monthly Income: RM ${monthlyIncome.toStringAsFixed(2)}"),
              pw.Text("Total Expenses: RM ${totalExpenses.toStringAsFixed(2)}"),
              pw.Text(
                  "Monthly Savings: RM ${monthlySavings.toStringAsFixed(2)}"),
              pw.Text("Yearly Savings: RM ${yearlySavings.toStringAsFixed(2)}"),
              pw.SizedBox(height: 20),
              pw.Text("Expense Breakdown:"),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ["Category", "Amount (RM)"],
                data: currentExpenses.entries
                    .map((e) => [e.key, e.value.toStringAsFixed(2)])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                  "Follow Niki Bhavi Vlogs on YouTube, GitHub, and Instagram for more tips!"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Expenses'];

    sheet.appendRow(["Category", "Amount (RM)"]);
    currentExpenses.forEach((key, value) {
      sheet.appendRow([key, value.toStringAsFixed(2)]);
    });

    sheet.appendRow([]);
    sheet.appendRow(["Monthly Income", monthlyIncome.toStringAsFixed(2)]);
    sheet.appendRow(["Total Expenses", totalExpenses.toStringAsFixed(2)]);
    sheet.appendRow(["Monthly Savings", monthlySavings.toStringAsFixed(2)]);
    sheet.appendRow(["Yearly Savings", yearlySavings.toStringAsFixed(2)]);

    final fileBytes = excel.save();
    if (fileBytes != null) {
      await Printing.sharePdf(
          bytes: Uint8List.fromList(fileBytes),
          filename: "LivingCostReport.xlsx");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auto Expense Calculator"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Family type dropdown
            DropdownButtonFormField<String>(
              value: _selectedFamilyType,
              items: [
                "Single",
                "Married",
                "Married + 1 Kid",
                "Married + 2 Kids"
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                if (val != null) _updateFamilyType(val);
              },
              decoration: const InputDecoration(
                labelText: "Family Type",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Income input
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Monthly Income (After Tax)",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  monthlyIncome = double.tryParse(val) ?? monthlyIncome;
                });
              },
            ),
            const SizedBox(height: 20),

            // Expense list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentExpenses.length,
              itemBuilder: (context, index) {
                String key = currentExpenses.keys.elementAt(index);
                return Card(
                  child: ListTile(
                    title: Text(key),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: currentExpenses[key]!.toStringAsFixed(0),
                        ),
                        onChanged: (val) {
                          setState(() {
                            currentExpenses[key] =
                                double.tryParse(val) ?? currentExpenses[key]!;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Summary
            Card(
              color: Colors.blue[50],
              child: ListTile(
                title: Text(
                    "Total Expenses: RM ${totalExpenses.toStringAsFixed(2)}"),
                subtitle: Text(
                    "Monthly Savings: RM ${monthlySavings.toStringAsFixed(2)}\nYearly Savings: RM ${yearlySavings.toStringAsFixed(2)}"),
              ),
            ),
            const SizedBox(height: 20),

            // Pie Chart of expenses

            const SizedBox(height: 30),

            // Yearly Savings Projection Bar Chart
            const Text(
              "Yearly Savings Projection",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 50)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text("M${value.toInt()}");
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(12, (i) {
                    final cumulativeSavings = (monthlySavings * (i + 1));
                    return BarChartGroupData(
                      x: i + 1,
                      barRods: [
                        BarChartRodData(
                          toY: cumulativeSavings,
                          color:
                              cumulativeSavings >= 0 ? Colors.blue : Colors.red,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Export buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _exportToPDF,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Export PDF"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
