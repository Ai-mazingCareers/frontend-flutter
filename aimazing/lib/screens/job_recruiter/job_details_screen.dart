import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aimazing/utils/constants.dart';
import 'applicant_screen.dart';

class JobDetailScreen extends StatelessWidget {
  Future<int> fetchApplicantCount(String jobId) async {
    final url =
        Uri.parse('http://10.0.2.2:5001/api/apply/applicants?job_id=$jobId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['count'];
      } else {
        throw Exception('Failed to load applicant count');
      }
    } catch (e) {
      rethrow;
    }
  }

  final Map<String, dynamic> job;

  const JobDetailScreen({Key? key, required this.job}) : super(key: key);

  Widget buildSection(String title, List<dynamic> items, IconData icon,
      {Color? iconColor}) {
    if (items.isEmpty) return SizedBox.shrink();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor ?? Colors.teal, size: 22),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: buttonColor),
                ),
              ],
            ),
            SizedBox(height: 8),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: Colors.teal[300]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(item, style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobId = job['_id'];
    final experience = job['experience_required'] ?? {};
    final education = List<String>.from(job['education_required'] ?? []);
    final skillsRequired = List<String>.from(job['skills_required'] ?? []);
    final skillsPreferred = List<String>.from(job['skills_preferred'] ?? []);
    final responsibilities = List<String>.from(job['responsibilities'] ?? []);
    final benefits = List<String>.from(job['benefits'] ?? []);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient AppBar with Hero animation for company avatar/logo
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: buttonColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                job['job_title'] ?? '',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [buttonColor, Colors.teal.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 24),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      backgroundImage: job['company_logo'] != null
                          ? NetworkImage(job['company_logo'])
                          : null,
                      child: job['company_logo'] == null
                          ? Icon(Icons.business, color: buttonColor, size: 36)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Company Name & Location
                  Text(job['company_name'] ?? '',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal[900])),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.teal[400], size: 18),
                      SizedBox(width: 4),
                      Text(job['location'] ?? '',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.work, color: Colors.teal[400], size: 18),
                      SizedBox(width: 4),
                      Text(job['employment_type'] ?? '',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Applicant count & View button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<int>(
                        future: fetchApplicantCount(jobId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Row(
                              children: [
                                CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.teal),
                                SizedBox(width: 8),
                                Text("Loading applicants...",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error loading applicants",
                                style: TextStyle(color: Colors.red));
                          } else {
                            return Row(
                              children: [
                                Icon(Icons.people, color: Colors.teal[700]),
                                SizedBox(width: 4),
                                Text(
                                  '${snapshot.data} applicant${snapshot.data == 1 ? '' : 's'}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal[800],
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ApplicantScreen(jobId: job['_id']),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward, size: 20),
                        label: Text("View Applicants"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          padding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Experience Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.timeline, color: Colors.teal[600]),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Experience",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: buttonColor)),
                                SizedBox(height: 6),
                                Text(
                                  "Minimum: ${experience['minimum_years'] ?? 0} years",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                                Text(
                                  "Preferred: ${experience['preferred_years'] ?? 0} years",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Other sections
                  buildSection("Education Required", education, Icons.school,
                      iconColor: Colors.blue[700]),
                  buildSection(
                      "Skills Required", skillsRequired, Icons.check_circle,
                      iconColor: Colors.orange[700]),
                  buildSection("Preferred Skills", skillsPreferred, Icons.star,
                      iconColor: Colors.amber[700]),
                  buildSection(
                      "Responsibilities", responsibilities, Icons.assignment,
                      iconColor: Colors.purple[700]),
                  buildSection("Benefits", benefits, Icons.card_giftcard,
                      iconColor: Colors.green[700]),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
