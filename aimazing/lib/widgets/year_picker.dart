import 'package:flutter/material.dart';

class YearPickerWidget extends StatefulWidget {
  final TextEditingController controller; // Controller to update the text field
  final String label; // Label for the year field
  final String? Function(String?)? validator; // Validator to validate the input

  const YearPickerWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.validator, // Validator can be passed
  }) : super(key: key);

  @override
  _YearPickerWidgetState createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  DateTime _selectedYear = DateTime.now();

  // Function to show the Year Picker dialog
  void selectYear(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select ${widget.label}"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1900), // Allow picking years from 1900
              lastDate: DateTime(9999), // Allow picking years up to 9999
              selectedDate: _selectedYear,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _selectedYear = dateTime;
                });
                widget.controller.text =
                    "${dateTime.year}"; // Update the text field with the selected year
                Navigator.pop(context); // Close the picker dialog
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectYear(context); // Open the year picker on tap
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: widget.controller, // Bind the controller
          decoration: InputDecoration(
            labelText: widget.label, // Use label passed to widget
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          readOnly: true, // Prevent manual input, show the picker instead
          validator: widget.validator, // Pass the validator here
        ),
      ),
    );
  }
}
