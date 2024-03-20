import 'package:flutter/material.dart';

void main() {
  runApp(StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      home: StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  bool _isRunning = false;
  Duration _elapsedTime = Duration.zero;
  late DateTime _startTime;
  List<String> _flagList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              _formatTime(_elapsedTime),
              style: TextStyle(fontSize: 48.0),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _startPausePressed,
                child: Text(_isRunning ? 'Pause' : 'Start'),
              ),
              ElevatedButton(
                onPressed: _stopPressed,
                child: Text('Stop'),
              ),
              ElevatedButton(
                onPressed: _flagPressed,
                child: Text('Flag'),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: _flagList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_flagList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startPausePressed() {
    setState(() {
      if (_isRunning) {
        _isRunning = false;
        _elapsedTime += DateTime.now().difference(_startTime);
        _startTime = DateTime.utc(0);
      } else {
        _isRunning = true;
        _startTime = DateTime.now();
      }
    });
    _updateTime();
  }

  void _stopPressed() {
    setState(() {
      _isRunning = false;
      _elapsedTime = Duration.zero;
      _startTime = DateTime.utc(0);
      _flagList.clear();
    });
  }

  void _flagPressed() {
    setState(() {
      _flagList.add(_formatTime(_elapsedTime));
    });
  }

  void _updateTime() {
    if (_isRunning) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (_isRunning) {
          setState(() {
            _elapsedTime = DateTime.now().difference(_startTime) +
                (_startTime != null ? _elapsedTime : Duration.zero);
          });
          _updateTime();
        }
      });
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitsMilliseconds(int n) {
      if (n >= 100) return "$n";
      if (n >= 10) return "0$n";
      return "00$n";
    }

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds =
        twoDigitsMilliseconds(duration.inMilliseconds.remainder(1000));
    return "$minutes:$seconds.$milliseconds";
  }
}
