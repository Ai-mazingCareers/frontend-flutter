import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'job_seeker/jobseeker_home.dart'; // Job Seeker Home
import 'job_recruiter/jobrecruiter_home.dart'; // Recruiter Home
import 'package:aimazing/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final ApiService _apiService = ApiService();

  bool _isLoading = false;

  String selectedRole = 'Job Seeker'; // Default role

  Future<void> _signup() async {
    // Basic field validation
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Email format validation
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Password match
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Optional: Password length validation
    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password should be at least 6 characters long',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      // Call the signup method
      final response = await _apiService.signup(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      // Check if the response contains a success message and user ID
      if (response.containsKey('userId') &&
          response['message'] == 'Signed up successfully') {
        // Show success Snackbar
        Get.snackbar(
          'Success',
          response['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate based on role
        if (selectedRole == 'Job Seeker') {
          Get.to(() => LoginScreen());
        } else {
          Get.to(() => LoginScreen());
        }
      } else {
        // If sign-up was not successful, show an error message
        Get.snackbar(
          'Signup Failed',
          'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Log and show error
      print('Signup error: $e');

      // Show a more descriptive error message
      String errorMessage = 'An unknown error occurred. Please try again.';

      if (e is Exception) {
        // Specific message based on exception type (network, server, etc.)
        errorMessage = e.toString();
      } else {
        // General case for unknown errors
        errorMessage = 'Something went wrong. Please try again later.';
      }

      // Display error message to user
      Get.snackbar(
        'Signup Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF89BDC2), // Background color
      body: SingleChildScrollView(
        child: Padding(
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
                        'Create Your Account',
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
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(color: Colors.blueGrey[900]),
                        ),
                        style: TextStyle(color: Colors.blueGrey[900]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter your Name',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(color: Colors.blueGrey[900]),
                        ),
                        style: TextStyle(color: Colors.blueGrey[900]),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(color: Colors.blueGrey[900]),
                        ),
                        obscureText: true,
                        style: TextStyle(color: Colors.blueGrey[900]),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(color: Colors.blueGrey[900]),
                        ),
                        obscureText: true,
                        style: TextStyle(color: Colors.blueGrey[900]),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _signup, // Disable button when loading
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3B7785),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),

                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Get.to(() => LoginScreen()),
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                              color: Color(0xFF3B7785)), // Updated color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
