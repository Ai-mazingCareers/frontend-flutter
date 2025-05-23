import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aimazing/widgets/job_card.dart';
import 'package:aimazing/screens/job_seeker/filter_options.dart'; // Import the JobCard widget
import 'package:aimazing/screens/job_seeker/ats_score_api.dart'; // Import the ATSScoreAPI class
import 'package:aimazing/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aimazing/screens/job_seeker/drawer.dart';

class JobSeekerHome extends StatefulWidget {
  @override
  _JobSeekerHomeState createState() => _JobSeekerHomeState();
}

class _JobSeekerHomeState extends State<JobSeekerHome> {
  Future<List<Map<String, dynamic>>> fetchJobs() async {
    final url = Uri.parse('http://10.0.2.2:5001/api/home');
    final response = await http.get(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('user_email'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((job) => job as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  // State variables for filters
  String? selectedLocation;
  String? selectedEmploymentType;

  List<Map<String, dynamic>> filteredJobs = [];
  List<Map<String, dynamic>> allJobs = [];
  bool isLoading = true; // Loading state

  // Filter jobs based on selected filters
  void applyFilters() {
    setState(() {
      if (selectedLocation == null && selectedEmploymentType == null) {
        // No filters applied, show all jobs
        filteredJobs = allJobs;
      } else {
        // Apply filters
        filteredJobs = allJobs.where((job) {
          final matchesLocation =
              selectedLocation == null || job['location'] == selectedLocation;
          final matchesEmploymentType = selectedEmploymentType == null ||
              job['employment_type'] == selectedEmploymentType;
          return matchesLocation && matchesEmploymentType;
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchJobs().then((jobs) {
      setState(() {
        allJobs = jobs;
        filteredJobs = jobs; // Initially show all jobs
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    });
  }

  void showATSScoreDialog(String jobId) async {
    // Retrieve the stored email ID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');

    if (userEmail == null) {
      // If email is not found, show an error or prompt the user to provide email
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please provide a valid email to fetch ATS score.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Create an instance of ATSScoreAPI
    final atsScoreAPI = ATSScoreAPI();

    try {
      // Fetch ATS score from the API
      Map<String, dynamic> atsData =
          await atsScoreAPI.fetchATSScore(userEmail, jobId);

      // Prepare content for the dialog
      String dialogContent =
          'Your ATS Score for this job is: ${atsData['score']}\n\n';

      // Check if feedback is available and append it
      if (atsData['feedback'] != null && atsData['feedback'].isNotEmpty) {
        dialogContent += 'Feedback:\n';
        for (var feedback in atsData['feedback']) {
          dialogContent += '$feedback\n';
        }
      }

      // Check if missing skills are available and append them
      if (atsData.containsKey('missingSkills') &&
          atsData['missingSkills'] != null &&
          atsData['missingSkills'].isNotEmpty) {
        dialogContent += '\nMissing Skills:\n';
        for (var skill in atsData['missingSkills']) {
          dialogContent += '$skill\n';
        }
      }

      // Check if missing certifications are available and append them
      if (atsData.containsKey('missingCertifications') &&
          atsData['missingCertifications'] != null &&
          atsData['missingCertifications'].isNotEmpty) {
        dialogContent += '\nMissing Certifications:\n';
        for (var certification in atsData['missingCertifications']) {
          dialogContent += '$certification\n';
        }
      }

      // Check if missing education is available and append it
      if (atsData.containsKey('missingEducation') &&
          atsData['missingEducation'] != null &&
          atsData['missingEducation'].isNotEmpty) {
        dialogContent += '\nMissing Education:\n';
        for (var education in atsData['missingEducation']) {
          dialogContent += '$education\n';
        }
      }

      // Show the dialog with all the information
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('ATS Score'),
            content: Text(dialogContent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Log the error to the console
      print('Error fetching ATS score: $e');

      // Show an error message if something goes wrong
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch ATS score. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [buttonColor, Colors.teal.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: buttonColor),
            ),
            SizedBox(width: 8),
            Text('Job Board',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            tooltip: "Filter Jobs",
            onPressed: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                context: context,
                builder: (context) => FilterOptions(
                  selectedLocation: selectedLocation,
                  selectedEmploymentType: selectedEmploymentType,
                  onApply: (location, employmentType) {
                    setState(() {
                      selectedLocation = location;
                      selectedEmploymentType = employmentType;
                    });
                    applyFilters();
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: buttonColor))
          : filteredJobs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text('No jobs found',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700])),
                      SizedBox(height: 8),
                      Text('Try adjusting your filters or check back later.',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    var job = filteredJobs[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: JobCard(
                        jobId: job['_id'],
                        jobTitle: job['job_title'] ?? 'No job title available',
                        companyName:
                            job['company_name'] ?? 'No company name available',
                        location: job['location'] ?? 'No location specified',
                        employmentType: job['employment_type'] ??
                            'No employment type specified',
                        salaryRange: job['salary_range'] != null
                            ? "\$${job['salary_range']['minimum'] ?? 'N/A'} - \$${job['salary_range']['maximum'] ?? 'N/A'} ${job['salary_range']['currency'] ?? 'USD'}"
                            : 'Salary range not available',
                        jobPostDate:
                            job['job_post_date'] ?? 'No post date available',
                        applicationDeadline: job['application_deadline'] ??
                            'No application deadline available',
                        jobDescription:
                            job['description'] ?? 'No description available',
                        jobRequirements:
                            job['requirements'] ?? 'No requirements specified',
                        atsScoreButton: IconButton(
                          icon: Icon(Icons.trending_up, color: Colors.teal),
                          tooltip: "Check your ATS score",
                          onPressed: () => showATSScoreDialog(job['_id']),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
