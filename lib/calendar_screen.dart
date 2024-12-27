import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart';
import 'add_exam_screen.dart'; // Import AddExamScreen

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = {}; // Initialize the events map
  }

  // Fetch events for a specific day from the database
  Future<void> _loadEventsForDay(DateTime day) async {
    String dateString =
        day.toIso8601String().substring(0, 10); // e.g., '2024-12-28'

    // Fetch events from the database for the selected day
    List<Map<String, dynamic>> eventsData =
        await DatabaseHelper().getEventsForDay(dateString);

    // Convert the events data into a list of Event objects
    List<Event> events = eventsData.map((event) {
      return Event(
        event['title'], // Exam title
        DateTime.parse(event['date_time']), // Date and time of the exam
        event['location'], // Location of the exam
      );
    }).toList();

    setState(() {
      _events[day] = events; // Store events for the day in the map
    });
  }

  // Get events for a day (return empty list if no events)
  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ??
        []; // Return the events if they exist, otherwise an empty list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the AddExamScreen when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExamScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31), // Extended to 2025
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              // Load events for the selected day
              _loadEventsForDay(selectedDay);
            },
            eventLoader: _getEventsForDay,

            // Custom styling for the calendar's days
            calendarBuilders: CalendarBuilders(
              // Customize the day number
              defaultBuilder: (context, day, focusedDay) {
                // Check if the day has any events
                bool hasEvent = _events[day]?.isNotEmpty ?? false;

                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: hasEvent
                        ? Colors.blue
                        : null, // Change color if there are events
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: hasEvent
                          ? Colors.white
                          : Colors.black, // Text color for events
                    ),
                  ),
                );
              },
            ),
          ),
          // Display selected day's events
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay).map((event) {
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text('${event.time}, ${event.location}'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String name;
  final DateTime time;
  final String location;

  Event(this.name, this.time, this.location);
}
