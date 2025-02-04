import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final TextEditingController controller; // Controller to update the text field
  final String label; // Label for the date field
  final String? Function(String?)? validator; // Validator to validate the input

  const DatePickerWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.validator, // Optional validator
  }) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _selectedDate = DateTime.now();

  // Function to show the Date Picker dialog
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date
      firstDate: DateTime(2000), // Minimum selectable date
      lastDate: DateTime(2101), // Maximum selectable date
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Update the selected date
      });
      widget.controller.text = "${picked.toLocal()}"
          .split(' ')[0]; // Update the text field with selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectDate(context); // Open the date picker on tap
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller:
              widget.controller, // Bind the controller to the text field
          decoration: InputDecoration(
            labelText: widget.label, // Use the passed label
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.calendar_today), // Show calendar icon
          ),
          readOnly: true, // Make it read-only to show date picker on tap
          validator: widget.validator, // Pass the validator here
        ),
      ),
    );
  }
}
