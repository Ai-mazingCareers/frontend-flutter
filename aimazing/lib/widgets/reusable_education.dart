import 'package:flutter/material.dart';
import 'package:aimazing/widgets/year_picker.dart';
import 'package:aimazing/widgets/custom_suggestion_field.dart';
import 'package:aimazing/fields/study_fields.dart'; // Assuming this widget handles year selection
import 'package:aimazing/fields/degree_fields.dart';

class ReusableEducationCard extends StatelessWidget {
  final TextEditingController degreeController;
  final TextEditingController fieldController;
  final TextEditingController instituteController;
  final TextEditingController startYearController;
  final TextEditingController endYearController;
  final TextEditingController cgpaController; // CGPA controller
  final VoidCallback onRemove;

  const ReusableEducationCard({
    Key? key,
    required this.degreeController,
    required this.fieldController,
    required this.instituteController,
    required this.startYearController,
    required this.endYearController,
    required this.cgpaController, // Add CGPA controller
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
              controller: degreeController,
              labelText: 'Degree',
              suggestions: degreeFields,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a degree';
                }
                return null;
              },

              // Pass the degreeFields list here
            ),
            SizedBox(height: 10),
            SuggestionTextField(
              controller: fieldController,
              labelText: 'study field',
              suggestions: studyFields,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a study field';
                }
                return null;
              },

              // Pass the degreeFields list here
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: instituteController,
              decoration: buildInputDecoration('Institute Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your institute name' : null,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: YearPickerWidget(
                    controller: startYearController,
                    label: 'Start Year',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a start year';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: YearPickerWidget(
                    controller: endYearController,
                    label: 'End Year',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an end year';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: cgpaController,
              decoration: buildInputDecoration('CGPA'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your CGPA' : null,
            ),
            SizedBox(height: 10),
            // Remove button for education card
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
