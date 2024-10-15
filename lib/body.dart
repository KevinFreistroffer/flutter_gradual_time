import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'gradual_clock.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  double calculateTimeChange() {
    const totalDays = 126;
    const minutesPerDay = 24 * 60;
    const totalMinutes = totalDays * minutesPerDay;
    const minutesToGain = 60;
    return minutesToGain / totalMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: GradualDSTClock(),
          ),
        ],
      ),
    );
  }
}
