import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApplicantScreen extends StatelessWidget {
  final String jobId;

  const ApplicantScreen({Key? key, required this.jobId}) : super(key: key);

  Future<List<dynamic>> fetchApplicants(String jobId) async {
    final url =
        Uri.parse('http://10.0.2.2:5001/api/apply/applicants?job_id=$jobId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['applicants'];
    } else {
      throw Exception('Failed to load applicants');
    }
  }

  void showApplicantDetails(BuildContext context, dynamic applicant) {
    showDialog(
      context: context,
      builder: (context) {
        final education = applicant['education'] ?? [];
        final experience = applicant['experience'] ?? [];
        final certifications = applicant['certifications'] ?? [];

        return AlertDialog(
          title: Text(applicant['name'] ?? 'Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${applicant['email'] ?? 'N/A'}'),
                Text('Phone: ${applicant['mobile'] ?? 'N/A'}'),
                SizedBox(height: 12),
                Text('Education:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...education.map<Widget>((edu) => Text(
                    '${edu['degree']} in ${edu['field']} from ${edu['institute']} (${edu['start_year']} - ${edu['end_year']})\nCGPA: ${edu['cgpa']}')),
                SizedBox(height: 12),
                Text('Experience:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...experience.map<Widget>((exp) => Text(
                    '${exp['title']} at ${exp['company']} (${exp['start_date']} - ${exp['end_date']})\nRole: ${exp['role']}')),
                SizedBox(height: 12),
                Text('Certifications:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...certifications.map<Widget>((cert) =>
                    Text('${cert['name']} by ${cert['issue_organization']}')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Close'))
          ],
        );
      },
    );
  }

  Widget buildAvatar(String? name) {
    if (name == null || name.isEmpty) {
      return CircleAvatar(child: Icon(Icons.person));
    }
    String initials = name.trim().split(' ').map((e) => e[0]).take(2).join();
    return CircleAvatar(child: Text(initials.toUpperCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Applicants")),
      body: FutureBuilder<List<dynamic>>(
        future: fetchApplicants(jobId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading applicants"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final applicants = snapshot.data!;
            return ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final applicant = applicants[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: buildAvatar(applicant['name']),
                    title: Text(applicant['name'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(applicant['email'] ?? 'No Email'),
                        Text(applicant['mobile'] ?? 'No Phone'),
                      ],
                    ),
                    onTap: () => showApplicantDetails(context, applicant),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No applicants found."));
          }
        },
      ),
    );
  }
}
