import 'package:flutter/material.dart';
import 'calendar_screen.dart';

void main() {
  runApp(const ExamScheduleApp());
}

class ExamScheduleApp extends StatelessWidget {
  const ExamScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Schedule App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const CalendarScreen(),
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}
