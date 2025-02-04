import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MultiSelectSuggestionTextField extends StatefulWidget {
  final String labelText;
  final List<String> suggestions;
  final String Function(String?)? validator;
  final Function(List<String>) onSelectedSkillsChanged;

  const MultiSelectSuggestionTextField({
    Key? key,
    required this.labelText,
    required this.suggestions,
    this.validator,
    required this.onSelectedSkillsChanged,
  }) : super(key: key);

  @override
  _MultiSelectSuggestionTextFieldState createState() =>
      _MultiSelectSuggestionTextFieldState();
}

class _MultiSelectSuggestionTextFieldState
    extends State<MultiSelectSuggestionTextField> {
  // List to hold selected skills
  List<String> selectedSkills = [];

  // Text controller to display selected skills
  final TextEditingController _textController = TextEditingController();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _textController,
            decoration: buildInputDecoration(widget.labelText),
            onTap: () {
              // Clear input when user focuses on the field
              _textController.clear();
            },
          ),
          suggestionsCallback: (pattern) {
            // Return suggestions that are not already selected
            return widget.suggestions.where((item) =>
                item.toLowerCase().contains(pattern.toLowerCase()) &&
                !selectedSkills.contains(item));
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            setState(() {
              selectedSkills.add(suggestion);
              widget.onSelectedSkillsChanged(selectedSkills);
              _textController.text = selectedSkills.join(", "); // Update field
            });
          },
          validator: widget.validator ??
              (value) => selectedSkills.isEmpty
                  ? 'Please select at least one skill'
                  : null,
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: selectedSkills
              .map(
                (skill) => Chip(
                  label: Text(skill),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      selectedSkills.remove(skill);
                      widget.onSelectedSkillsChanged(selectedSkills);
                      _textController.text = selectedSkills.join(", ");
                    });
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
