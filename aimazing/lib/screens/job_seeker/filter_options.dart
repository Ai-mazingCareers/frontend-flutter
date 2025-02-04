import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  final String? selectedLocation;
  final String? selectedEmploymentType;
  final void Function(String?, String?) onApply;

  const FilterOptions({
    Key? key,
    this.selectedLocation,
    this.selectedEmploymentType,
    required this.onApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? location = selectedLocation;
    String? employmentType = selectedEmploymentType;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Options',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: location,
            items: ['Location 1', 'Location 2', 'Location 3']
                .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                .toList(),
            onChanged: (value) {
              location = value;
            },
            decoration: InputDecoration(labelText: 'Location'),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: employmentType,
            items: ['Full-time', 'Part-Time', 'Internship']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              employmentType = value;
            },
            decoration: InputDecoration(labelText: 'Employment Type'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onApply(location, employmentType),
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
