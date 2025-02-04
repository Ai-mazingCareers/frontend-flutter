import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SuggestionTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final List<String> suggestions;
  final String? Function(String?)? validator;

  const SuggestionTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.suggestions,
    this.validator,
  }) : super(key: key);

  @override
  _SuggestionTextFieldState createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField> {
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
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: buildInputDecoration(widget.labelText),
      ),
      suggestionsCallback: (pattern) {
        return widget.suggestions.where(
            (item) => item.toLowerCase().contains(pattern.toLowerCase()));
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        widget.controller.text = suggestion;
      },
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a value';
            }
            return null;
          },
    );
  }
}
