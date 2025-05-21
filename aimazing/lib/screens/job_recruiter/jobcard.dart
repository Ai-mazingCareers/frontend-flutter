import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String employmentType;
  final int minExperience;
  final int preferredExperience;
  final List<String> educationRequired;

  const JobCard({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.employmentType,
    required this.minExperience,
    required this.preferredExperience,
    required this.educationRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jobTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('$companyName • $location', style: TextStyle(fontSize: 14)),
            SizedBox(height: 4),
            Text('Employment: $employmentType'),
            SizedBox(height: 4),
            Text('Experience: $minExperience - $preferredExperience years'),
            SizedBox(height: 4),
            Text('Education: ${educationRequired.join(", ")}'),
          ],
        ),
      ),
    );
  }
}
