import 'package:aimazing/screens/job_seeker/features/ats_recommendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:aimazing/utils/constants.dart';
import 'package:get/get.dart';
import 'package:aimazing/screens/job_seeker/jobseeker_home.dart';
import 'package:aimazing/screens/job_seeker/features/resume_recommendation.dart'; // Import ResumeRecommendation screen
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aimazing/utils/constants.dart';
// Import your screens as needed

class CustomDrawer extends StatefulWidget {
  // You can pass user info via constructor or provider
  final String? avatarUrl;

  const CustomDrawer({
    Key? key,
    this.avatarUrl,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String savedEmail = '';
  String savedName = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedEmail = prefs.getString('userEmail') ?? '';
      savedName = prefs.getString('name') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(36),
        bottomRight: Radius.circular(36),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Enhanced DrawerHeader
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [buttonColor, Colors.teal.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: widget.avatarUrl != null
                    ? NetworkImage(widget.avatarUrl!)
                    : null,
                child: widget.avatarUrl == null
                    ? Icon(Icons.person, size: 40, color: buttonColor)
                    : null,
              ),
              accountName: Text(
                savedName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                savedEmail,
                style: TextStyle(fontSize: 14),
              ),
            ),
            // Section Label
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
              child: Text(
                "Navigation",
                style: TextStyle(
                  color: Colors.teal[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1,
                ),
              ),
            ),
            DrawerItem(
              icon: Icons.home,
              label: 'Home',
              onTap: () {
                Navigator.pop(context);
                Get.to(JobSeekerHome());
              },
            ),
            DrawerItem(
              icon: Icons.person,
              label: 'Profile',
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile screen
              },
            ),
            DrawerItem(
              icon: Icons.receipt,
              label: 'ATS based recommendation',
              onTap: () {
                Navigator.pop(context);
                Get.to(AtsRecommendationScreen());
              },
            ),
            DrawerItem(
              icon: Icons.dashboard,
              label: 'Analysis',
              onTap: () {
                Navigator.pop(context);
                // Navigate to analysis
              },
            ),
            Divider(thickness: 1, indent: 18, endIndent: 18),
            DrawerItem(
              icon: Icons.exit_to_app,
              label: 'Log Out',
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                // Add logout logic
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Custom ListTile for better feedback and style
class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const DrawerItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: Icon(icon, color: iconColor ?? buttonColor),
            title: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hoverColor: Colors.teal.withOpacity(0.1),
            splashColor: Colors.teal.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
