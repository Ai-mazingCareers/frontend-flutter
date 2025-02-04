import 'package:aimazing/screens/job_seeker/features/ats_recommendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:aimazing/utils/constants.dart';
import 'package:get/get.dart';
import 'package:aimazing/screens/job_seeker/jobseeker_home.dart';
import 'package:aimazing/screens/job_seeker/features/resume_recommendation.dart'; // Import ResumeRecommendation screen

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: buttonColor,
            ),
            child: Text(
              'Features',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Get.to(JobSeekerHome());
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('ATS based recommendation'),
            onTap: () {
              Navigator.pop(context);
              Get.to(
                  AtsRecommendationScreen()); // Navigate to ResumeRecommendation
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('analysis'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
