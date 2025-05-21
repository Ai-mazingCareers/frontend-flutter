import 'package:flutter/material.dart';
import 'package:aimazing/screens/job_recruiter/job_post_form.dart';
import 'package:aimazing/screens/job_recruiter/jobcard.dart'; // Update the path as needed
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aimazing/utils/constants.dart';
import 'package:get/get.dart';
import 'package:aimazing/screens/job_recruiter/job_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecruiterHome extends StatefulWidget {
  @override
  _RecruiterHomeState createState() => _RecruiterHomeState();
}

class _RecruiterHomeState extends State<RecruiterHome> {
  List<dynamic> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    print(prefs.getString('userEmail')); // Make sure 'email' key is correct

    final url =
        'http://10.0.2.2:5001/api/job?job_posted_by=hr@techinnovations.com';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          jobs = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Fetch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recruiter Dashboard')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? Center(child: Text('No jobs available'))
              : ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final experience = job['experience_required'] ?? {};
                    final education = job['education_required'] ?? [];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailScreen(job: job),
                          ),
                        );
                      },
                      child: JobCard(
                        jobTitle: job['job_title'] ?? '',
                        companyName: job['company_name'] ?? '',
                        location: job['location'] ?? '',
                        employmentType: job['employment_type'] ?? '',
                        minExperience: experience['minimum_years'] ?? 0,
                        preferredExperience: experience['preferred_years'] ?? 0,
                        educationRequired: List<String>.from(education),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.off(() => JobPostFormScreen());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: buttonColor,
      ),
    );
  }
}
