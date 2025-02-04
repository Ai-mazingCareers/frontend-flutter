import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aimazing/fields/degree_fields.dart';
import 'package:flutter/material.dart';
import 'package:aimazing/utils/constants.dart';
import 'package:aimazing/widgets/multi_select_skills.dart';
import 'package:aimazing/fields/skills_suggestion.dart';
import 'package:get/get.dart';
import 'package:aimazing/widgets/date_picker.dart';
import 'package:intl/intl.dart';

class JobPostFormScreen extends StatefulWidget {
  @override
  _JobPostFormScreenState createState() => _JobPostFormScreenState();
}

class _JobPostFormScreenState extends State<JobPostFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _salaryMinController = TextEditingController();
  final TextEditingController _salaryMaxController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _applicationDeadlineController =
      TextEditingController();
  final TextEditingController _experienceMinController =
      TextEditingController();
  final TextEditingController _experiencePreferredController =
      TextEditingController();

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final String currency = 'USD';

  // Dropdown and multi-select values
  String _jobType = 'Full-time';
  List<String> requiredSkills = [];
  List<String> preferredSkills = [];
  List<String> preferredCertifications = [];
  List<String> requiredEducation = [];

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _locationController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _jobDescriptionController.dispose();
    _applicationDeadlineController.dispose();
    _experienceMinController.dispose();
    _experiencePreferredController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic> jobPostData = {
      "job_title": _jobTitleController.text,
      "company_name": _companyNameController.text,
      "location": _locationController.text,
      "employment_type": _jobType,
      "experience_required": {
        "minimum_years": int.parse(_experienceMinController.text),
        "preferred_years": int.parse(_experiencePreferredController.text),
      },
      "education_required": requiredEducation,
      "skills_required": requiredSkills,
      "skills_preferred": preferredSkills,
      "certifications_preferred": preferredCertifications,
      "job_post_date": formattedDate,
      "application_deadline": _applicationDeadlineController.text,
      "salary_range": {
        "minimum": int.parse(_salaryMinController.text),
        "maximum": int.parse(_salaryMaxController.text),
        "currency": currency,
      },
      "job_posted_by": _emailController.text,
    };

    String jsonJobPostData = json.encode(jobPostData);

    const String apiUrl = "http://10.0.2.2:2400/api/job";

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_TOKEN", // Add token if required
        },
        body: jsonJobPostData,
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Job posted successfully!");
        print("Response: ${response.body}");

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Job posted successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("Failed to post job. Status code: ${response.statusCode}");
        print("Response: ${response.body}");

        // Show error SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to post job. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred while posting job: $e");

      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "An error occurred. Please check your connection and try again."),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Print to console in the desired format
    print(jsonJobPostData);
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
        title: Text('Post a Job', style: TextStyle(color: Colors.white)),
        backgroundColor: buttonColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Job Details',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: buttonColor),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _jobTitleController,
                decoration: buildInputDecoration('Job Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the job title' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _jobDescriptionController,
                decoration: buildInputDecoration('Job Description'),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'please enter job description' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _companyNameController,
                decoration: buildInputDecoration('Company Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the company name' : null,
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
                controller: _locationController,
                decoration: buildInputDecoration('Location'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the location' : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _jobType,
                items: ['Full-time', 'Part-time', 'Remote']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jobType = value!;
                  });
                },
                decoration: buildInputDecoration('Job Type'),
              ),
              SizedBox(height: 20),
              Text(
                'Educational Requirements',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: buttonColor),
              ),
              SizedBox(height: 10),
              MultiSelectSuggestionTextField(
                labelText: "required education",
                suggestions: degreeFields,
                onSelectedSkillsChanged: (skills) {
                  setState(() {
                    requiredEducation = skills;
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                'Experience Requirements',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: buttonColor),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _experienceMinController,
                      decoration: buildInputDecoration('Minimum (years)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        final numValue = num.tryParse(value);
                        if (numValue == null) {
                          return 'enter minimum years';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _experiencePreferredController,
                      decoration: buildInputDecoration('Preferred (years)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enter preferred years';
                        }
                        final numValue = num.tryParse(value);
                        if (numValue == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Skills Requirements',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: buttonColor),
              ),
              SizedBox(height: 10),
              MultiSelectSuggestionTextField(
                labelText: "Required Skills",
                suggestions: skillSuggestions,
                onSelectedSkillsChanged: (skills) {
                  setState(() {
                    requiredSkills = skills;
                  });
                },
              ),
              SizedBox(height: 10),
              MultiSelectSuggestionTextField(
                labelText: "Preferred Skills",
                suggestions: skillSuggestions,
                onSelectedSkillsChanged: (skills) {
                  setState(() {
                    preferredSkills = skills;
                  });
                },
              ),
              SizedBox(height: 10),
              MultiSelectSuggestionTextField(
                labelText: "Preferred Certifications",
                suggestions: [
                  "AWS Certified Solutions Architect",
                  "Certified Kubernetes Administrator (CKA)",
                ],
                validator: null,
                onSelectedSkillsChanged: (certifications) {
                  setState(() {
                    preferredCertifications = certifications;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _salaryMinController,
                      decoration: buildInputDecoration('Minimum Salary (USD)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        final numValue = num.tryParse(value);
                        if (numValue == null) {
                          return 'enter minimum years';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _salaryMaxController,
                      decoration: buildInputDecoration('Maximum Salary (USD)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        final numValue = num.tryParse(value);
                        if (numValue == null) {
                          return 'enter minimum years';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DatePickerWidget(
                controller: _applicationDeadlineController,
                label: 'Application Deadline',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a start date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child:
                      Text('Post Job', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
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
