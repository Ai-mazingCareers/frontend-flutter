import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_screen.dart';
import 'job_seeker/jobseeker_home.dart'; // Assuming it's the home screen for job seekers
import 'job_recruiter/jobrecruiter_home.dart'; // Assuming it's the home screen for recruiters
import 'package:aimazing/utils/constants.dart';
import 'job_seeker/resume_form_screen.dart';
import 'job_recruiter/job_post_form.dart';
import 'package:aimazing/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedRole = 'Job Seeker'; // Default role

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password cannot be empty');
      return;
    }

    final response = await ApiService.loginUser(email, password);

    if (response.containsKey('error')) {
      Get.snackbar('Login Failed', response['error']);
    } else {
      final user = response['user'];
      final token = response['token'];

      // Save token or user data if needed (SharedPreferences etc.)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userName', user['name']);
      await prefs.setString('userEmail', user['email']);

      Get.snackbar('Success', 'Welcome ${user['name']}');

      if (selectedRole == 'Job Seeker') {
        Get.to(() => ResumeFormScreen());
      } else {
        Get.to(() => JobPostFormScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ai-mazing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Role Selection Dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Role:',
                          style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedRole,
                          dropdownColor: Colors.white,
                          items: ['Job Seeker', 'Recruiter']
                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(
                                      role,
                                      style: TextStyle(
                                          color: Colors.blueGrey[900]),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.blueGrey[900]),
                      ),
                      style: TextStyle(color: Colors.blueGrey[900]),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.blueGrey[900]),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.blueGrey[900]),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      child:
                          Text('Login', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor, // Use variable here
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Get.to(() => SignupScreen());
                      },
                      child: Text(
                        'Don\'t have an account? Register here!',
                        style:
                            TextStyle(color: buttonColor), // Use variable here
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
