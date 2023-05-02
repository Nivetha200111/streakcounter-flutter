import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streak Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreakCounterPage(),
    );
  }
}

class StreakCounterPage extends StatefulWidget {
  @override
  _StreakCounterPageState createState() => _StreakCounterPageState();
}

class _StreakCounterPageState extends State<StreakCounterPage> {
  int _streakCount = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DateTime> _streakDates = [];

  void _incrementStreak() {
    if (_selectedDay != null) {
      setState(() {
        DateTime currentDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
        if (!_streakDates.any((date) => isSameDay(date, currentDate))) {
          _streakDates.add(currentDate);
        }
        _streakCount = _calculateCurrentStreak();
        if (_streakCount % 10 == 0) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Congratulations!'),
              content: TyperAnimatedTextKit(
                text: [
                  'You have achieved a ${_streakCount.toString()} day streak!',
                ],
                speed: Duration(milliseconds: 50),
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      });
    }
  }

  int _calculateCurrentStreak() {
    if (_streakDates.isEmpty) {
      return 0;
    }

    _streakDates.sort((a, b) => b.compareTo(a));
    int currentStreak = 1;
    for (int i = 0; i < _streakDates.length - 1; i++) {
      if (_streakDates[i].difference(_streakDates[i + 1]).inDays == 1) {
        currentStreak++;
      } else {
        break;
      }
    }

    return currentStreak;
  }

  CalendarBuilders _calendarBuilders() {
    return CalendarBuilders(
      markerBuilder: (context, date, events) {
        if (_streakDates.any((streakDate) => isSameDay(streakDate, date))) {
          return Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              width: 16,
              height: 16,
              child: Center(
                child: Text(
                  '✓',
                  style: TextStyle().copyWith(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streak Counter App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2021, 1, 1),
