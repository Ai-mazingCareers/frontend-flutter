import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aimazing/utils/constants.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeRecommendation extends StatefulWidget {
  final String keyword; // Add a keyword field to receive job role

  ResumeRecommendation(
      {required this.keyword}); // Constructor to accept keyword

  @override
  _ResumeRecommendationState createState() => _ResumeRecommendationState();
}

class _ResumeRecommendationState extends State<ResumeRecommendation> {
  List<dynamic> jobs = [];
  bool isLoading = true;

  final String email =
      'yashjoshi@gmail.com'; // You can replace with the actual user email

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail =
        prefs.getString('userEmail') ?? ''; // fallback in case it's null

    final url =
        'http://10.0.2.2:5001/api/home/search?keyword=${widget.keyword}&email=$savedEmail'; // Use widget.keyword here
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          jobs = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error fetching jobs: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void showJobDetailsDialog(BuildContext context, dynamic job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(job['job_title'] ?? 'No job title available'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Company: ${job['company_name'] ?? 'N/A'}'),
                Text('Location: ${job['location'] ?? 'N/A'}'),
                Text('Employment Type: ${job['employment_type'] ?? 'N/A'}'),
                Text(
                    'Salary Range: ${job['salary_range'] != null ? "\$${job['salary_range']['minimum']} - \$${job['salary_range']['maximum']} ${job['salary_range']['currency']}" : 'N/A'}'),
                Text('Job Posted: ${job['job_post_date'] ?? 'N/A'}'),
                Text(
                    'Application Deadline: ${job['application_deadline'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Responsibilities:'),
                for (var responsibility in job['responsibilities'] ?? [])
                  Text('- $responsibility'),
                SizedBox(height: 10),
                Text('Skills Required:'),
                for (var skill in job['skills_required'] ?? [])
                  Text('- $skill'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resume Recommendation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: buttonColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? Center(child: Text('No jobs available'))
              : ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    var job = jobs[index];
                    return JobCard(
                      jobTitle: job['job_title'] ?? 'No job title available',
                      companyName:
                          job['company_name'] ?? 'No company name available',
                      location: job['location'] ?? 'No location specified',
                      employmentType: job['employment_type'] ??
                          'No employment type specified',
                      salaryRange: job['salary_range'] != null
                          ? "\$${job['salary_range']['minimum']} - \$${job['salary_range']['maximum']} ${job['salary_range']['currency']}"
                          : 'Salary range not available',
                      atsScore: job['atsScore'] ?? 0, // Pass ATS score
                      jobDetails: job, // Pass full job details
                    );
                  },
                ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String employmentType;
  final String salaryRange;
  final int atsScore;
  final dynamic jobDetails; // Store full job details

  JobCard({
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.employmentType,
    required this.salaryRange,
    required this.atsScore,
    required this.jobDetails, // Initialize job details
  });

  void showJobDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(jobTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Company: $companyName'),
                Text('Location: $location'),
                Text('Employment Type: $employmentType'),
                Text('Salary Range: $salaryRange'),
                Text('Job Posted: ${jobDetails['job_post_date'] ?? 'N/A'}'),
                Text(
                    'Application Deadline: ${jobDetails['application_deadline'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Responsibilities:'),
                for (var responsibility in jobDetails['responsibilities'] ?? [])
                  Text('- $responsibility'),
                SizedBox(height: 10),
                Text('Skills Required:'),
                for (var skill in jobDetails['skills_required'] ?? [])
                  Text('- $skill'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Apply'),
                    content: Text('You have applied successfully!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              child: Text(
                'Apply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showJobDetailsDialog(context);
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(companyName),
                    SizedBox(height: 5),
                    Text(location),
                    SizedBox(height: 5),
                    Text('Employment Type: $employmentType'),
                    SizedBox(height: 5),
                    Text('Salary Range: $salaryRange'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        showJobDetailsDialog(
                            context); // Show job details dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor, // Apply button color
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 8.0,
                    percent: atsScore / 100, // Convert 0-100 scale
                    center: Text(
                      "$atsScore",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    progressColor: atsScore >= 80
                        ? Colors.green
                        : atsScore >= 50
                            ? Colors.orange
                            : Colors.red, // Change color based on score
                    backgroundColor: Colors.grey[300]!,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  Text("ATS score"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
