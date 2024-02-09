import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() {
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderScreen(),
    );
  }
}

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  int selectedDay = 0;
  String selectedTime = "12:00 AM";
  String selectedActivity = "Wake up";

  // Audio player instance
  final player = AudioCache();

  // Reminder activities
  final activities = [
    "Wake up",
    "Go to gym",
    "Breakfast",
    "Meetings",
    "Lunch",
    "Quick nap",
    "Go to library",
    "Dinner",
    "Go to sleep"
  ];

  // Function to handle reminder setting
  void setReminder() {
    // Get current datetime
    DateTime now = DateTime.now();
    DateTime selectedDateTime =
        DateTime(now.year, now.month, now.day, _getHour(selectedTime),
            _getMinute(selectedTime));

    // Check if it's time for reminder
    if (now.hour == selectedDateTime.hour &&
        now.minute == selectedDateTime.minute) {
      String activity = selectedActivity;
      player.play('sound.wav'); // Play sound
      print("Time to $activity!");
    }
  }

  // Helper function to get hour from time string
  int _getHour(String time) {
    return int.parse(time.split(":")[0]);
  }

  // Helper function to get minute from time string
  int _getMinute(String time) {
    return int.parse(time.split(":")[1].split(" ")[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<int>(
              value: selectedDay,
              onChanged: (newValue) {
                setState(() {
                  selectedDay = newValue!;
                });
              },
              items: List.generate(7, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(_getDayOfWeek(index)),
                );
              }),
            ),
            DropdownButton<String>(
              value: selectedTime,
              onChanged: (newValue) {
                setState(() {
                  selectedTime = newValue!;
                });
              },
              items: List.generate(24, (index) {
                String time = (index % 12 + 1).toString() +
                    ":" +
                    (index % 2 == 0 ? "00" : "30") +
                    " " +
                    (index < 12 ? "AM" : "PM");
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }),
            ),
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (newValue) {
                setState(() {
                  selectedActivity = newValue!;
                });
              },
              items: activities.map((activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: setReminder,
              child: Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get day of week
  String _getDayOfWeek(int dayIndex) {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[dayIndex];
  }
}
