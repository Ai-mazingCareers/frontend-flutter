import 'package:aimazing/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aimazing/screens/job_seeker/features/resume_recommendation.dart'; // Correct import
import 'package:aimazing/widgets/custom_suggestion_field.dart';
import 'package:aimazing/fields/job_titles.dart';

class AtsRecommendationScreen extends StatefulWidget {
  @override
  _AtsRecommendationScreenState createState() =>
      _AtsRecommendationScreenState();
}

class _AtsRecommendationScreenState extends State<AtsRecommendationScreen> {
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: Text(
          'Job Recommendation',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        // Centering the entire body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center elements vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center elements horizontally
              children: [
                Text(
                  'ATS Based Recommendation',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 239, 122, 114),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Select Job role'),
                SizedBox(
                  height: 10,
                ),
                // SuggestionTextField widget inside the form
                SuggestionTextField(
                  controller: controller,
                  labelText: 'Select job role',
                  suggestions: jobTitles,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a skill';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Once form is validated, replace space with '%'
                      String selectedJobRole =
                          controller.text.replaceAll(' ', '%');
                      Get.to(ResumeRecommendation(keyword: selectedJobRole));
                    }
                  },
                  child: const Column(
                    children: [
                      Text(
                        'Recommend',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16, // Adjust font size if needed
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
