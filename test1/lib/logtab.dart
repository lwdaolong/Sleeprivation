import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Sleeprivation_Day.dart';
import 'globals.dart' as globals;
import 'Personal_Model.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class LogTab extends StatefulWidget {
  const LogTab({super.key});

  // List<String> logs = <String>['bob', 'joe'];
  @override
  State<LogTab> createState() => _MyLogTab();
}

class _MyLogTab extends State<LogTab> {
  String getDateWithoutTime(DateTime d) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter
        .format(d); //ensures entries are just date, time not included
  }

  String getDateWithoutMilliSeconds(DateTime d) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    return formatter
        .format(d); //ensures entries are just date, time not included
  }

  @override
  Widget build(BuildContext context) {
    // for (final t in globals.allLogs!) {
    //   print('=====');
    //   print(t.getDate().toString());
    //   if (t.didActivity()) print(t.getActivity()!.getSteps().toString());
    //   if (t.hadCaffeine()) print(t.getCaffeine()!.caffeine_time.toString());

    //   print(t.getSleep()!.sleep_start.toString());
    //   print(t.getSleep()!.sleep_end.toString());
    //   print(t.getSleep()!.sleep_quality.toString());
    //   print(t.getSleep()!.sleep_duration.toString());
    //   print('=====');
    // }

    return ListView.builder(
      itemCount: globals.allLogs!.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  width: 300,
                  height: 110,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            '${getDateWithoutTime(globals.allLogs![index].getDate()!).toString()}',
                            style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            'Sleep Quality: ${(globals.allLogs![index].getSleep()!.sleep_quality / 10).toInt().toString()}/10',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                            'Sleep Time: ${getDateWithoutMilliSeconds(globals.allLogs![index].getSleep()!.sleep_start).toString()}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                            'Wake Time: ${getDateWithoutMilliSeconds(globals.allLogs![index].getSleep()!.sleep_start).toString()}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                            'Last Caffeine Intake: ${globals.allLogs![index].getCaffeine() == null ? 'no caffeine today' : getDateWithoutMilliSeconds(globals.allLogs![index].getCaffeine()!.caffeine_time!).toString()}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                            'Number of Steps: ${globals.allLogs![index].getActivity() == null ? 'no steps today' : globals.allLogs![index].getActivity()!.getSteps()!.toString()}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ])),
            ),
          ),
        );
      },
      // scrollDirection: Axis.vertical,
    );
  }
}
