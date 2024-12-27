import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the database helper

class AddExamScreen extends StatefulWidget {
  @override
  _AddExamScreenState createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _examDateTime = DateTime.now();

  // Function to submit the exam event
  void _submitExam() {
    final String title = _titleController.text;
    final String location = _locationController.text;

    // Check if the title and location are not empty
    if (title.isEmpty || location.isEmpty) {
      // Show a warning if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both title and location')),
      );
      return;
    }

    final exam = {
      'title': title,
      'location': location,
      'date_time':
          _examDateTime.toIso8601String(), // Convert DateTime to a string
    };

    // Insert the exam into the database
    DatabaseHelper().insertExam(exam);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exam event saved successfully!')),
    );

    // Optionally, navigate back after saving
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exam Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Exam Title Input Field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Exam Title'),
            ),
            // Exam Location Input Field
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Exam Location'),
            ),
            // Date Picker for selecting date
            ListTile(
              title: Text('Date: ${_examDateTime.toLocal()}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _examDateTime,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _examDateTime) {
                  setState(() {
                    _examDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      _examDateTime.hour,
                      _examDateTime.minute,
                    );
                  });
                }
              },
            ),
            // Time Picker for selecting time
            ListTile(
              title: Text(
                  'Time: ${_examDateTime.toLocal().toString().substring(11, 16)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_examDateTime),
                );
                if (pickedTime != null) {
                  setState(() {
                    _examDateTime = DateTime(
                      _examDateTime.year,
                      _examDateTime.month,
                      _examDateTime.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                }
              },
            ),
            // Save Button
            ElevatedButton(
              onPressed: _submitExam,
              child: const Text('Save Exam'),
            ),
          ],
        ),
      ),
    );
  }
}
