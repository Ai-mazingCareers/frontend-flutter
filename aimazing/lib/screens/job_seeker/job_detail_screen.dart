// job_detail_screen.dart
import 'package:flutter/material.dart';

class JobDetailScreen extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String employmentType;
  final String salaryRange;
  final String jobPostDate;
  final String applicationDeadline;
  final String jobDescription;
  final String jobRequirements;

  const JobDetailScreen({
    Key? key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.employmentType,
    required this.salaryRange,
    required this.jobPostDate,
    required this.applicationDeadline,
    required this.jobDescription,
    required this.jobRequirements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              companyName,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              'Location: $location',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Employment Type: $employmentType',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              salaryRange,
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Posted on: $jobPostDate | Deadline: $applicationDeadline',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            SizedBox(height: 16),
            Text(
              'Job Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(jobDescription),
            SizedBox(height: 16),
            Text(
              'Job Requirements:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(jobRequirements),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Apply Now button press
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Applied for $jobTitle at $companyName'),
                    ),
                  );
                },
                child: Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
