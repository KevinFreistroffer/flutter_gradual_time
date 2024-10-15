import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class GradualDSTClock extends StatefulWidget {
  const GradualDSTClock({Key? key}) : super(key: key);

  @override
  _GradualDSTClockState createState() => _GradualDSTClockState();
}

class _GradualDSTClockState extends State<GradualDSTClock> {
  late DateTime _currentTime;
  late Timer _timer;
  Duration _totalAdjustment = Duration.zero;
  bool _showStats = false;
  late DateTime _dstStart;
  late DateTime _dstEnd;
  Duration _totalDSTAdjustment = const Duration(hours: 1);

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    _updateDSTDates();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      final DateTime now = DateTime.now();
      _currentTime = _getAdjustedTime(now);
      _totalAdjustment += _currentTime.difference(now);
      _updateDSTDates();
    });
  }

  void _updateDSTDates() {
    final int currentYear = DateTime.now().year;
    _dstStart = _getDSTStartDate(currentYear);
    _dstEnd = _getDSTEndDate(currentYear);
  }

  DateTime _getAdjustedTime(DateTime now) {
    final int year = now.year;
    final DateTime dstStart = _getDSTStartDate(year);
    final DateTime dstEnd = _getDSTEndDate(year);

    if (now.isAfter(dstStart) && now.isBefore(dstEnd)) {
      // During DST period (March to November)
      // Clock should run faster, so we subtract time
      final double progress = now.difference(dstStart).inSeconds /
          dstEnd.difference(dstStart).inSeconds;
      final int adjustmentSeconds = (3600 * progress).round();
      return now.subtract(Duration(seconds: adjustmentSeconds));
    } else if (now.isAfter(dstEnd) || now.isBefore(dstStart)) {
      // Outside DST period (November to March)
      // Clock should run slower, so we add time
      final DateTime previousDSTEnd =
          now.isAfter(dstEnd) ? dstEnd : _getDSTEndDate(year - 1);
      final DateTime nextDSTStart =
          now.isBefore(dstStart) ? dstStart : _getDSTStartDate(year + 1);
      final double progress = now.difference(previousDSTEnd).inSeconds /
          nextDSTStart.difference(previousDSTEnd).inSeconds;
      final int adjustmentSeconds = (3600 * progress).round();
      return now.add(Duration(seconds: adjustmentSeconds));
    }

    return now; // No adjustment needed on DST transition days
  }

  DateTime _getDSTStartDate(int year) {
    // Second Sunday in March for the US
    return DateTime(year, 3, 1)
        .add(Duration(days: (14 - DateTime(year, 3, 1).weekday) % 7));
  }

  DateTime _getDSTEndDate(int year) {
    // First Sunday in November for the US
    return DateTime(year, 11, 1)
        .add(Duration(days: (7 - DateTime(year, 11, 1).weekday) % 7));
  }

  Duration _getCurrentAdjustment() {
    final DateTime now = DateTime.now();
    if (now.isAfter(_dstStart) && now.isBefore(_dstEnd)) {
      final double progress = now.difference(_dstStart).inSeconds /
          _dstEnd.difference(_dstStart).inSeconds;
      final int adjustmentSeconds = (3600 * progress).round();
      return Duration(seconds: adjustmentSeconds);
    } else if (now.isAfter(_dstEnd) || now.isBefore(_dstStart)) {
      final DateTime previousDSTEnd =
          now.isAfter(_dstEnd) ? _dstEnd : _getDSTEndDate(now.year - 1);
      final DateTime nextDSTStart =
          now.isBefore(_dstStart) ? _dstStart : _getDSTStartDate(now.year + 1);
      final double progress = now.difference(previousDSTEnd).inSeconds /
          nextDSTStart.difference(previousDSTEnd).inSeconds;
      final int adjustmentSeconds = (3600 * progress).round();
      return Duration(seconds: adjustmentSeconds);
    }
    return Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('HH:mm:ss').format(_currentTime),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showStats = !_showStats;
              });
            },
            child: Text(_showStats ? 'Hide Stats' : 'Show Stats'),
          ),
          if (_showStats) ...[
            const SizedBox(height: 20),
            Text(
              'Minutes: ${_getCurrentAdjustment().inMinutes}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Seconds: ${_getCurrentAdjustment().inSeconds % 60}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Microseconds: ${_getCurrentAdjustment().inMicroseconds % 1000000}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
