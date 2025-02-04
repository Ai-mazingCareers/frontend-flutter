import 'package:aimazing/fields/job_titles.dart';
import 'package:flutter/material.dart';
import 'package:aimazing/widgets/date_picker.dart';
import 'package:aimazing/widgets/custom_suggestion_field.dart';
import 'package:aimazing/fields/job_role.dart';

class ReusableExperienceCard extends StatelessWidget {
  final TextEditingController jobTitleController;
  final TextEditingController companyController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController jobRoleController;
  final VoidCallback onRemove;

  const ReusableExperienceCard({
    Key? key,
    required this.jobTitleController,
    required this.companyController,
    required this.startDateController,
    required this.endDateController,
    required this.jobRoleController,
    required this.onRemove,
  }) : super(key: key);

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SuggestionTextField(
              controller: jobTitleController,
              labelText: 'Job title',
              suggestions: jobTitles,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a job title';
                }
                return null;
              }, // Pass the degreeFields list here
            ),
            SizedBox(height: 10),
            SuggestionTextField(
              controller: jobRoleController,
              labelText: 'Job role',
              suggestions: jobRole,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a job role';
                }
                return null;
              }, // Pass the degreeFields list here
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: companyController,
              decoration: buildInputDecoration('Company '),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your company name' : null,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DatePickerWidget(
                    controller: startDateController,
                    label: 'Start Date',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a start date';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DatePickerWidget(
                    controller: endDateController,
                    label: 'End Date',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a end date';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
