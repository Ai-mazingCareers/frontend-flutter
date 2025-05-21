import 'package:flutter/material.dart';
import 'package:aimazing/utils/constants.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailScreen({Key? key, required this.job}) : super(key: key);

  Widget buildSection(String title, List<dynamic> items) {
    if (items.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: buttonColor)),
            SizedBox(height: 8),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: Colors.black54),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(item,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
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
    final experience = job['experience_required'] ?? {};
    final education = List<String>.from(job['education_required'] ?? []);
    final skillsRequired = List<String>.from(job['skills_required'] ?? []);
    final skillsPreferred = List<String>.from(job['skills_preferred'] ?? []);
    final responsibilities = List<String>.from(job['responsibilities'] ?? []);
    final benefits = List<String>.from(job['benefits'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: buttonColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(job['job_title'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(job['company_name'] ?? '',
                style: TextStyle(fontSize: 18, color: Colors.grey[700])),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.teal),
                SizedBox(width: 4),
                Text(job['location'] ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.work, color: Colors.teal),
                SizedBox(width: 4),
                Text(job['employment_type'] ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal.shade100),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Experience",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Minimum: ${experience['minimum_years'] ?? 0} years",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    "Preferred: ${experience['preferred_years'] ?? 0} years",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            buildSection("Education Required", education),
            buildSection("Skills Required", skillsRequired),
            buildSection("Preferred Skills", skillsPreferred),
            buildSection("Responsibilities", responsibilities),
            buildSection("Benefits", benefits),
          ],
        ),
      ),
    );
  }
}
