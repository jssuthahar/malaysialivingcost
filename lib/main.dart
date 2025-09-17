import 'package:flutter/material.dart';
import 'auto_expense_page.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malaysia Living Cost Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(), // ✅ Splash first
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Social links
  final String youtubeUrl = "https://www.youtube.com/@nikibhavi";
  final String githubUrl = "https://github.com/jssuthahar";
  final String instagramUrl = "https://www.instagram.com/nikibhavi/";

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  Widget _buildPromoCard({
    required Color color,
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
    bool highlight = false,
  }) {
    return Card(
      color: highlight ? Colors.blue[50] : color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: highlight ? 6 : 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: highlight ? FontWeight.w900 : FontWeight.bold,
                color: highlight ? Colors.blue[900] : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: Colors.white),
              label: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: highlight ? Colors.blue : Colors.black87,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🇲🇾 Malaysia Living Cost & Savings Calculator 🇲🇾",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // YouTube card
            _buildPromoCard(
              color: Colors.red[50]!,
              icon: Icons.play_circle_fill,
              title: "📺 Follow on YouTube!",
              description:
                  "Get Malaysia living tips, savings hacks, and vlogs.",
              buttonText: "Subscribe to Niki Bhavi Vlogs",
              onPressed: () => _launchURL(youtubeUrl),
            ),

            const SizedBox(height: 15),

            // GitHub card
            _buildPromoCard(
              color: Colors.grey[200]!,
              icon: Icons.code,
              title: "💻 Explore Projects on GitHub!",
              description:
                  "Check out source code, projects, and tech experiments.",
              buttonText: "View on GitHub",
              onPressed: () => _launchURL(githubUrl),
            ),

            const SizedBox(height: 15),

            // Instagram card
            _buildPromoCard(
              color: Colors.purple[50]!,
              icon: Icons.camera_alt,
              title: "📸 Follow on Instagram!",
              description: "Daily lifestyle, travel, and personal updates.",
              buttonText: "Follow on Instagram",
              onPressed: () => _launchURL(instagramUrl),
            ),

            const SizedBox(height: 15),

            // Highlighted Expense Calculator card
            _buildPromoCard(
              color: Colors.blue[50]!,
              icon: Icons.calculate,
              title: "🚀 Start Expense Calculator",
              description:
                  "Plan your monthly expenses, family costs, and savings easily.",
              buttonText: "Open Calculator",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AutoExpensePage()),
                );
              },
              highlight: true, // ✅ standout style
            ),
          ],
        ),
      ),
    );
  }
}
