import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auto_expense_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // External links
  final String youtubeUrl = "https://www.youtube.com/@nikibhavi";
  final String githubUrl = "https://github.com/jssuthahar";
  final String instagramUrl = "https://www.instagram.com/nikibhavi/";
  final String coffeeUrl = "https://buymeacoffee.com/jssuthahar";
  final String meetingUrl = "https://topmate.io/jssuthahar/711026";
  final String taxUrl = "https://jssuthahar.github.io/malaysiatax/";

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Malaysia Living & Finance",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Header Banner ---
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFFE53935)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "🇲🇾 Malaysia Expense Tools",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Calculate, plan, and explore your lifestyle smartly.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- Smart Tools Section (Modern Cards) ---
          _buildSmartToolsSection(context),

          const SizedBox(height: 30),

          // --- Connect Section ---
          Text(
            "Connect & Learn",
            style: theme.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          _buildSocialCard(
            context,
            icon: Icons.play_circle_fill,
            color: Colors.redAccent,
            title: "YouTube - Niki Bhavi Vlogs",
            subtitle: "Malaysia living, vlogs & lifestyle insights",
            onTap: () => _launchURL(youtubeUrl),
          ),
          _buildSocialCard(
            context,
            icon: Icons.code,
            color: Colors.black87,
            title: "GitHub Projects",
            subtitle: "Explore open-source finance & tax tools",
            onTap: () => _launchURL(githubUrl),
          ),
          _buildSocialCard(
            context,
            icon: Icons.camera_alt,
            color: Colors.pinkAccent,
            title: "Instagram Updates",
            subtitle: "Personal stories & behind-the-scenes moments",
            onTap: () => _launchURL(instagramUrl),
          ),

          const SizedBox(height: 20),
          _buildSupportBanner(context),
        ],
      ),
    );
  }

  // --- Smart Tools (Professional Cards) ---
  Widget _buildSmartToolsSection(BuildContext context) {
    final List<Map<String, dynamic>> tools = [
      {
        "title": "Expense Calculator",
        "subtitle": "Track daily and monthly costs",
        "icon": Icons.calculate_outlined,
        "color": Colors.blueAccent,
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AutoExpensePage()),
          );
        }
      },
      {
        "title": "Tax Calculator",
        "subtitle": "Estimate yearly income tax",
        "icon": Icons.account_balance_wallet_outlined,
        "color": Colors.green,
        "action": () => _launchURL("https://jssuthahar.github.io/malaysiatax/"),
      },
      {
        "title": "Buy Me a Coffee",
        "subtitle": "Support the creator ☕",
        "icon": Icons.local_cafe_outlined,
        "color": Colors.brown,
        "action": () => _launchURL("https://buymeacoffee.com/jssuthahar"),
      },
      {
        "title": "Book Meeting",
        "subtitle": "1:1 mentorship or discussion",
        "icon": Icons.video_call_outlined,
        "color": Colors.purple,
        "action": () => _launchURL("https://topmate.io/jssuthahar/711026"),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Smart Tools",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...tools.map((tool) {
          return GestureDetector(
            onTap: tool["action"],
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.15),
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: (tool["color"] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tool["icon"], color: tool["color"]),
                ),
                title: Text(
                  tool["title"],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                subtitle: Text(
                  tool["subtitle"],
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // --- Social Cards (YouTube, GitHub, Instagram) ---
  Widget _buildSocialCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }

  // --- Support Banner ---
  Widget _buildSupportBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Text(
            "💡 Support the Creator",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87),
          ),
          const SizedBox(height: 10),
          const Text(
            "If you find these tools useful, consider supporting via coffee ☕ or a quick chat 💬.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.coffee, color: Colors.white),
                label: const Text("Buy Me a Coffee"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () =>
                    _launchURL("https://buymeacoffee.com/jssuthahar"),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.video_call, color: Colors.white),
                label: const Text("Setup Meeting"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () =>
                    _launchURL("https://topmate.io/jssuthahar/711026"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
