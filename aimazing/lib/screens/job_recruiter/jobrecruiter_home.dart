import 'package:flutter/material.dart';
import 'package:aimazing/screens/job_recruiter/job_post_form.dart';
import 'package:aimazing/screens/job_recruiter/jobcard.dart';
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
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail') ?? 'hr@techinnovations.com';
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
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No jobs posted yet!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the "+" button to post your first job.',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildJobList() {
    return RefreshIndicator(
      onRefresh: fetchJobs,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          final experience = job['experience_required'] ?? {};
          final education = job['education_required'] ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetailScreen(job: job),
                  ),
                );
              },
              child: Hero(
                tag: 'job_${job['_id']}',
                child: Material(
                  color: Colors.transparent,
                  child: JobCard(
                    jobTitle: job['job_title'] ?? '',
                    companyName: job['company_name'] ?? '',
                    location: job['location'] ?? '',
                    employmentType: job['employment_type'] ?? '',
                    minExperience: experience['minimum_years'] ?? 0,
                    preferredExperience: experience['preferred_years'] ?? 0,
                    educationRequired: List<String>.from(education),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient AppBar with profile icon
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.dashboard, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Recruiter Dashboard',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: buttonColor),
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [buttonColor, Colors.teal.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: buttonColor))
            : (jobs.isEmpty ? _buildEmptyState() : _buildJobList()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.off(() => JobPostFormScreen());
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Post Job", style: TextStyle(color: Colors.white)),
        backgroundColor: buttonColor,
        elevation: 4,
      ),
    );
  }
}
