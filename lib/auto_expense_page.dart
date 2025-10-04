import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;

class AutoExpensePage extends StatefulWidget {
  const AutoExpensePage({super.key});

  @override
  State<AutoExpensePage> createState() => _AutoExpensePageState();
}

class _AutoExpensePageState extends State<AutoExpensePage> {
  String _selectedFamilyType = "Single";
  double monthlyIncome = 5000;

  Map<String, Map<String, double>> defaultExpenses = {};
  Map<String, double> currentExpenses = {}; // Initialize as empty

  bool _isLoading = true; // Add loading flag

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final String data = await rootBundle.loadString('assets/expenses.json');
    final Map<String, dynamic> jsonResult = json.decode(data);

    defaultExpenses = jsonResult.map((key, value) => MapEntry(
        key,
        Map<String, double>.from(
            value.map((k, v) => MapEntry(k, (v as num).toDouble())))));

    setState(() {
      currentExpenses = Map.from(defaultExpenses[_selectedFamilyType]!);
      _isLoading = false; // Set loading to false
    });
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

    // Sanitize expenses: ensure all values are double and not null
    final sanitizedExpenses = currentExpenses.map((key, value) =>
        MapEntry(key, (value is double && value != null) ? value : 0.0));

    // Filter out zero values
    final filteredExpenses =
        sanitizedExpenses.entries.where((e) => e.value != 0.0).toList();

    try {
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
                pw.Text(
                    "Monthly Income: RM ${monthlyIncome.toStringAsFixed(2)}"),
                pw.Text(
                    "Total Expenses: RM ${totalExpenses.toStringAsFixed(2)}"),
                pw.Text(
                    "Monthly Savings: RM ${monthlySavings.toStringAsFixed(2)}"),
                pw.Text(
                    "Yearly Savings: RM ${yearlySavings.toStringAsFixed(2)}"),
                pw.SizedBox(height: 20),
                pw.Text("Expense Breakdown:"),
                pw.SizedBox(height: 10),
                filteredExpenses.isNotEmpty
                    ? pw.Table.fromTextArray(
                        headers: ["Category", "Amount (RM)"],
                        data: filteredExpenses
                            .map((e) => [
                                  e.key,
                                  e.value.toStringAsFixed(2),
                                ])
                            .toList(),
                      )
                    : pw.Text("No expense data available."),
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export PDF: $e')),
        );
      }
    }
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
    if (_isLoading || currentExpenses.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final sanitizedExpenses = <String, double>{};
    currentExpenses.forEach((key, value) {
      sanitizedExpenses[key] = (value is double && value != null) ? value : 0.0;
    });
    final filteredExpenses =
        sanitizedExpenses.entries.where((e) => e.value != 0.0).toList();
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
                            final parsed = double.tryParse(val);
                            currentExpenses[key] = parsed ?? 0.0;
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
