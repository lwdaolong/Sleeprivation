import 'dart:io';

import 'Sleep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'rectab.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:test1/Sleeprivation_Day.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'globals.dart' as globals;

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _MyHomeTab();
}

class _MyHomeTab extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    if (globals.dataEntered) {
      return RecTab();
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Looks like you haven\'t entered your sleep data for today',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    side: BorderSide(width: 1),
                  ),
                  child: Text('Enter data',
                      style: Theme.of(context).textTheme.bodyLarge),
                  onPressed: () async {
                    var finishedDataEntry = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => EnterDataModal(),
                        builder: (context) => DailyDataForm(),
                      ),
                    );
                    if (finishedDataEntry) {
                      setState(() {
                        globals.dataEntered = true;
                      });
                    }
                  }),
            ),
          ],
        ),
      );
    }
  }
}

class DailyDataForm extends StatefulWidget {
  DailyDataForm({super.key});

  @override
  MyDailyDataForm createState() {
    return MyDailyDataForm();
  }
}

class MyDailyDataForm extends State<DailyDataForm> {
  final _DailyDataFormKey = GlobalKey<FormState>();
  double _sleepScore = 5;
  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;

  void _handleSubmitted() async {
    final FormState form = _DailyDataFormKey.currentState!;

    if (sleepTime == null || wakeTime == null) {
      showSimpleNotification(const Text("Please enter sleep and wake times"));
    } else {
      form.save();
      Sleeprivation_Day? yest = await globals.loggedInUser?.retrieveYesterday();
      DateTime? bedtime =
          globals.loggedInUser?.getDateTimeFromTimeOfDay(sleepTime!);
      DateTime? waketime =
          globals.loggedInUser?.getDateTimeFromTimeOfDay(wakeTime!);
      yest!.setSleep(Sleep(bedtime!, waketime!, _sleepScore.toInt() * 10));
      await globals.loggedInUser?.setSleeprivationDayinLogsDB(yest);
      //re fetch data
      globals.allLogs = await globals.loggedInUser!.getAllLogsDB();
      globals.recCards = globals.loggedInUser?.getRankedRecommendations();
      for (final rec in globals.recCards!) {
        rec.debuglog();
      }
      if (globals.loggedInUser!.today.getActivity()! == null) {
        globals.currentSteps = 0;
      } else {
        globals.currentSteps =
            globals.loggedInUser!.today.getActivity()!.getSteps();
      }

      print("$_sleepScore");
      print(sleepTime);
      print(wakeTime);
      Navigator.pop(context, true);
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text('Enter Data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _DailyDataFormKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Text('How would you rate the quality of your sleep last night?',
                    style: Theme.of(context).textTheme.bodyLarge),
                // SizedBox(height: 10),
                // SleepRatingSlider(),
                Slider(
                  value: _sleepScore,
                  max: 10,
                  divisions: 10,
                  label: _sleepScore.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _sleepScore = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(width: 1, color: Colors.red),
                        ),
                        onPressed: () async {
                          sleepTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          showSimpleNotification(Text(
                              'Slept at ${sleepTime!.hour.toString().padLeft(2, '0')}:${sleepTime!.minute.toString().padLeft(2, '0')}!'));
                        },
                        child: Text('Enter Sleep Time')),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(width: 1, color: Colors.red),
                        ),
                        onPressed: () async {
                          wakeTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          showSimpleNotification(Text(
                              'Woke up at ${wakeTime!.hour.toString().padLeft(2, '0')}:${wakeTime!.minute.toString().padLeft(2, '0')}!'));
                        },
                        child: Text('Enter Wake Time'))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(width: 1),
                        ),
                        child: Text('Submit data',
                            style: Theme.of(context).textTheme.bodyLarge),
                        // onPressed: () {
                        //   Navigator.pop(context, true);
                        // }),
                        onPressed: _handleSubmitted)
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
