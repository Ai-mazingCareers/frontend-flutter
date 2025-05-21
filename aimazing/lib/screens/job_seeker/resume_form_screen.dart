import 'package:flutter/material.dart';
import 'package:aimazing/utils/constants.dart';
import 'package:aimazing/fields/skills_suggestion.dart';
import 'package:aimazing/widgets/multi_select_skills.dart';
import 'package:aimazing/widgets/reusable_experience_widget.dart';
import 'package:aimazing/widgets/reusable_education.dart';
import 'package:aimazing/widgets/custom_suggestion_field.dart';
import 'package:aimazing/fields/certification_issue.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:aimazing/screens/job_seeker/jobseeker_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeFormScreen extends StatefulWidget {
  @override
  _ResumeFormScreenState createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _objectiveController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<Map<String, TextEditingController>> _experienceControllers = [];
  final List<Map<String, TextEditingController>> _educationControllers = [];

  final TextEditingController _certificationNameController =
      TextEditingController();
  final TextEditingController _issuingOrgController = TextEditingController();
  List<String> selectedSkills = [];

  void _addEducationCard() {
    setState(() {
      _educationControllers.add({
        'degree': TextEditingController(),
        'field': TextEditingController(),
        'institute': TextEditingController(),
        'startYear': TextEditingController(),
        'endYear': TextEditingController(),
        'cgpa': TextEditingController(), // Add CGPA controller
      });
    });
  }

  void _removeEducationCard(int index) {
    setState(() {
      _educationControllers.removeAt(index);
    });
  }

//expereince card logic
  void _addExperienceCard() {
    setState(() {
      _experienceControllers.add({
        'jobTitle': TextEditingController(),
        'company': TextEditingController(),
        'startDate': TextEditingController(),
        'endDate': TextEditingController(),
        'jobRole': TextEditingController(),
      });
    });
  }

  void _removeExperienceCard(int index) {
    setState(() {
      _experienceControllers.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _addExperienceCard();
    _addEducationCard();
    // Add initial experience card
  }

  @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    for (var controllers in _experienceControllers) {
      controllers.values.forEach((controller) => controller.dispose());
    }
    for (var controllers in _educationControllers) {
      controllers.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  void _submitForm() async {
    Get.off(() => JobSeekerHome());
    // Validate all form fields first
    if (!_formKey.currentState!.validate()) {
      // If the main form is invalid, show error and return
      return;
    }

    // Prepare the data in the desired JSON format
    Map<String, dynamic> resumeData = {
      "name": _nameController.text,
      "email": _emailController.text,
      "mobile": _contactController.text,
      "education": _educationControllers.map((controllers) {
        return {
          "degree": controllers['degree']!.text,
          "field": controllers['field']!.text,
          "institute": controllers['institute']!.text,
          "start_year": int.parse(controllers['startYear']!.text),
          "end_year": int.parse(controllers['endYear']!.text),
          "cgpa": double.parse(controllers['cgpa']!.text),
        };
      }).toList(),
      "skills": selectedSkills,
    };

// Conditionally add optional fields
    if (_objectiveController.text.isNotEmpty) {
      resumeData["objective"] = _objectiveController.text;
    }

    if (_experienceControllers.isNotEmpty) {
      resumeData["experience"] = _experienceControllers.map((controllers) {
        return {
          "title": controllers['jobTitle']!.text,
          "role": controllers['jobRole']!.text,
          "company": controllers['company']!.text,
          "start_date": controllers['startDate']!.text,
          "end_date": controllers['endDate']!.text,
        };
      }).toList();
    }

    if (_certificationNameController.text.isNotEmpty &&
        _issuingOrgController.text.isNotEmpty) {
      resumeData["certifications"] = [
        {
          "name": _certificationNameController.text,
          "issue_organization": _issuingOrgController.text,
        }
      ];
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', _emailController.text);

    String jsonResumeData = json.encode(resumeData);
    const String apiUrl = "http://10.0.2.2:5001/api/resume";

    try {
      // Make a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_TOKEN",
        },
        body: jsonResumeData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Resume submitted successfully!");
        print("Response: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Resume submitted successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Get.off(() => JobSeekerHome());
      } else {
        print("Failed to submit resume. Status code: ${response.statusCode}");
        print("Response: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to submit resume. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Exception occurred: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }

    print("Resume Data in JSON: ");
    print(jsonResumeData);
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resume Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: buttonColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              Text(
                'Personal Infomation',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: buttonColor),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: buildInputDecoration('Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: buildInputDecoration('email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  // Simple email validation
                  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contactController,
                decoration: buildInputDecoration('Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your contact number';
                  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit contact number';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              // Objective Field
              TextFormField(
                controller: _objectiveController,
                decoration: buildInputDecoration('Objective'),
              ),
              SizedBox(height: 20),
              // Education Section Header
              Text(
                'Education',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              SizedBox(height: 10),
              ..._educationControllers.asMap().entries.map((entry) {
                int index = entry.key;
                var controllers = entry.value;
                return ReusableEducationCard(
                  degreeController: controllers['degree']!,
                  fieldController: controllers['field']!,
                  instituteController: controllers['institute']!,
                  startYearController: controllers['startYear']!,
                  endYearController: controllers['endYear']!,
                  cgpaController: controllers['cgpa']!,
                  onRemove: () => _removeEducationCard(index),
                );
              }).toList(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addEducationCard,
                child: Text(
                  "Add Education",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
              ),
              SizedBox(height: 20),
              // Experience Section Header
              Text(
                'Experience',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              SizedBox(height: 10),
              ..._experienceControllers.asMap().entries.map((entry) {
                int index = entry.key;
                var controllers = entry.value;
                return ReusableExperienceCard(
                  jobTitleController: controllers['jobTitle']!,
                  companyController: controllers['company']!,
                  startDateController: controllers['startDate']!,
                  endDateController: controllers['endDate']!,
                  jobRoleController: controllers['jobRole']!,
                  onRemove: () => _removeExperienceCard(index),
                );
              }).toList(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addExperienceCard,
                child: Text(
                  "Add Experience",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
              ),

              SizedBox(height: 20),
              Text(
                'Skills',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              SizedBox(height: 10),
              MultiSelectSuggestionTextField(
                labelText: "Skills",
                suggestions: skillSuggestions,
                onSelectedSkillsChanged: (skills) {
                  setState(() {
                    selectedSkills = skills;
                  });
                },
              ),
              SizedBox(height: 10),
              // Certifications Section
              Text(
                'Certifications',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _certificationNameController,
                decoration: buildInputDecoration('Certification Name'),
              ),
              SizedBox(height: 10),
              SuggestionTextField(
                controller: _issuingOrgController,
                labelText: 'issuning organization',
                suggestions: certifications,

                // Pass the degreeFields list here
              ),

              SizedBox(height: 30),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Use variable here
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
