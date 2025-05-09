import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/job_seeker/resume_form_screen.dart';
import 'screens/job_recruiter/job_post_form.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required before async calls in main

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final role = prefs.getString('role'); // 'Job Seeker' or 'Recruiter'

  Widget initialScreen;

  if (token != null && role != null) {
    if (role == 'Job Seeker') {
      initialScreen = ResumeFormScreen();
    } else {
      initialScreen = JobPostFormScreen();
    }
  } else {
    initialScreen = LoginScreen();
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  MyApp({required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Amazing Career',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialScreen,
    );
  }
}
