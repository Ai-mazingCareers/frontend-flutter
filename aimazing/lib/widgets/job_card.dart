import 'package:aimazing/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:aimazing/screens/job_seeker/job_detail_screen.dart'; // Import the JobDetailScreen

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String employmentType;
  final String salaryRange;
  final String jobPostDate;
  final String applicationDeadline;
  final String jobDescription;
  final String jobRequirements;
  final Widget atsScoreButton; // Add this line to accept ATS score button

  const JobCard({
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
    required this.atsScoreButton, // Include atsScoreButton in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show dialog with job details and Apply button
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(jobTitle),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company: $companyName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Location: $location'),
                    SizedBox(height: 8),
                    Text('Employment Type: $employmentType'),
                    SizedBox(height: 8),
                    Text('Salary: $salaryRange',
                        style: TextStyle(color: Colors.green)),
                    SizedBox(height: 8),
                    Text('Posted on: $jobPostDate'),
                    SizedBox(height: 8),
                    Text('Application Deadline: $applicationDeadline'),
                    SizedBox(height: 16),
                    Text(
                      'Job Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(jobDescription),
                    SizedBox(height: 16),
                    Text(
                      'Requirements:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(jobRequirements),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Close'),
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
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Apply'),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                companyName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 4),
              Text(
                location,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Employment Type: $employmentType',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                salaryRange,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Posted on: $jobPostDate | Deadline: $applicationDeadline',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 16),
              // Row for buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  atsScoreButton, // Display the passed ATS score button
                  ElevatedButton(
                    onPressed: () {
                      // Handle apply button click
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
