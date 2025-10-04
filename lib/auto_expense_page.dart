import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class AutoExpensePage extends StatefulWidget {
  const AutoExpensePage({super.key});

  @override
  State<AutoExpensePage> createState() => _AutoExpensePageState();
}

class _AutoExpensePageState extends State<AutoExpensePage> {
  String _selectedFamilyType = "Single";
  double monthlyIncome = 5000;

  Map<String, Map<String, double>> defaultExpenses = {};
  Map<String, double> currentExpenses = {};
  bool _isLoading = true;

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
      _isLoading = false;
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
    final sanitizedExpenses = currentExpenses.map((key, value) =>
        MapEntry(key, (value is double && value != null) ? value : 0.0));
    final filteredExpenses =
        sanitizedExpenses.entries.where((e) => e.value != 0.0).toList();

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
              filteredExpenses.isNotEmpty
                  ? pw.Table.fromTextArray(
                      headers: ["Category", "Amount (RM)"],
                      data: filteredExpenses
                          .map((e) => [e.key, e.value.toStringAsFixed(2)])
                          .toList(),
                    )
                  : pw.Text("No expense data available."),
              pw.SizedBox(height: 20),
              pw.Text(
                  "Follow Niki Bhavi Vlogs on YouTube, GitHub, and Instagram!"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || currentExpenses.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 4,
        title: const Text(
          "Auto Expense Calculator",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.family_restroom, color: Colors.redAccent),
                        SizedBox(width: 8),
                        Text("Family Configuration",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedFamilyType,
                      items: [
                        "Single",
                        "Married",
                        "Married + 1 Kid",
                        "Married + 2 Kids"
                      ]
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) _updateFamilyType(val);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.people_outline),
                        labelText: "Select Family Type",
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.attach_money),
                        labelText: "Monthly Income (After Tax)",
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          monthlyIncome = double.tryParse(val) ?? monthlyIncome;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Expense list
            Text("Expense Breakdown",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    )),
            const SizedBox(height: 10),
            ...currentExpenses.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.category_outlined,
                      color: Colors.redAccent),
                  title: Text(entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: entry.value.toStringAsFixed(0),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                          final parsed = double.tryParse(val);
                          currentExpenses[entry.key] = parsed ?? 0.0;
                        });
                      },
                    ),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // Summary section
            Card(
              color: Colors.redAccent.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Summary",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                        "💰 Total Expenses: RM ${totalExpenses.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 15)),
                    Text(
                        "💵 Monthly Savings: RM ${monthlySavings.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 15)),
                    Text(
                        "📅 Yearly Savings: RM ${yearlySavings.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Bar Chart
            const Text(
              "Yearly Savings Projection",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text("M${value.toInt()}",
                              style: const TextStyle(fontSize: 10));
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
                          gradient: LinearGradient(colors: [
                            Colors.redAccent,
                            Colors.orangeAccent,
                          ]),
                          width: 16,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Export button
            Center(
              child: ElevatedButton.icon(
                onPressed: _exportToPDF,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Export PDF"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
