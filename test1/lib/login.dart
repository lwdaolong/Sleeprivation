import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:test1/Goals.dart';
import 'globals.dart' as globals;
import 'Personal_Model.dart';
import 'Sleeprivation_Day.dart';
import 'dart:convert';

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  LoginForm({super.key, required this.title});
  final String title;

  @override
  MyLoginForm createState() {
    return MyLoginForm();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyLoginForm extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String? _username;

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
    } else {
      form.save();
      Personal_Model? new_user = await Personal_Model.loginUser("$_username");
      if (new_user == null) {
        showSimpleNotification(Text("User does not exist"));
      } else {
        globals.loggedInUser = new_user;
        globals.allLogs = await new_user!.getAllLogsDB();
        // if (lastDay.getSleep() == null ||
        //     lastDay.getSleep()!.sleep_start == null) {
        //   globals.dataEntered = false;
        // } else {
        //   globals.dataEntered = true;
        // }

        // if (globals.dataEntered == true) {
        globals.recCards = globals.loggedInUser?.getRankedRecommendations();
        for (final rec in globals.recCards!) {
          rec.debuglog();
        }
        if (globals.loggedInUser!.today.getActivity() == null) {
          globals.currentSteps = 0;
        } else {
          globals.currentSteps =
              globals.loggedInUser!.today.getActivity()!.getSteps();
        }
        // }
        if (globals.allLogs!.isEmpty) {
          globals.dataEntered = false;
        } else {
          Sleeprivation_Day lastDay = globals.allLogs![0];
          if (lastDay.getSleep() == null) {
            globals.dataEntered = false;
          } else {
            globals.dataEntered = true;
          }
        }

        // DateTime lastDay = globals.allLogs![0].getDate()!;
        // DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
        // if (lastDay.day == yesterday.day &&
        //     lastDay.month == yesterday.month &&
        //     lastDay.year == yesterday.year) {
        //   globals.dataEntered = true;
        // }

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', ModalRoute.withName('/home'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter Login Info",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                    onSaved: (String? value) {
                      _username = value;
                    },
                  ),
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        side: BorderSide(width: 1, color: Colors.black)),
                    // onPressed: () {
                    //   if (_formKey.currentState!.validate()) {
                    //     Navigator.of(context).pushNamedAndRemoveUntil(
                    //         '/home', ModalRoute.withName('/home'));
                    //   }
                    // },
                    onPressed: _handleSubmitted,
                    child: Text("Login",
                        style: Theme.of(context).textTheme.titleMedium)),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        side: BorderSide(width: 1, color: Colors.black)),
                    // onPressed: () {
                    //   if (_formKey.currentState!.validate()) {
                    //     Navigator.of(context).pushNamedAndRemoveUntil(
                    //         '/home', ModalRoute.withName('/home'));
                    //   }
                    // },
                    onPressed: () async {
                      var finishedDataEntry = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => EnterDataModal(),
                          builder: (context) => SignupForm(),
                        ),
                      );
                    },
                    child: Text("Signup",
                        style: Theme.of(context).textTheme.titleMedium))
              ],
            ),
          ))
        ])));
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({super.key});

  @override
  MySignupForm createState() {
    return MySignupForm();
  }
}

class MySignupForm extends State<SignupForm> {
  final _SignupFormKey = GlobalKey<FormState>();
  int? goalSleepAmount;
  TimeOfDay? goalWakeTime;
  String? newUsername;
  // TimeOfDay? wakeTime;

  void _handleSubmitted() async {
    final FormState form = _SignupFormKey.currentState!;
    form.save();
    print(goalSleepAmount);
    print(goalWakeTime);
    print(newUsername);

    if (goalWakeTime == null || goalSleepAmount == null || newUsername == "") {
      showSimpleNotification(const Text("Please enter all data"));
    } else {
      // PersonalMocreateNewUser(newUsername, goalSleepAmount);
      Personal_Model? new_user = await Personal_Model.createNewUser(
          newUsername!, Goals(goalSleepAmount!, goalWakeTime!));
      if (new_user == null) {
        showSimpleNotification(Text("User already exists"));
      } else {
        Navigator.pop(context, true);
      }

      // form.save();
      //   Sleeprivation_Day? yest = await globals.loggedInUser?.retrieveYesterday();
      //   DateTime? bedtime =
      //       globals.loggedInUser?.getDateTimeFromTimeOfDay(sleepTime!);
      //   DateTime? waketime =
      //       globals.loggedInUser?.getDateTimeFromTimeOfDay(wakeTime!);
      //   yest!.setSleep(Sleep(bedtime!, waketime!, _sleepScore.toInt() * 10));
      //   await globals.loggedInUser?.setSleeprivationDayinLogsDB(yest);
      //   //re fetch data
      //   globals.allLogs = await globals.loggedInUser!.getAllLogsDB();
      //   globals.recCards = globals.loggedInUser?.getRankedRecommendations();
      //   for (final rec in globals.recCards!) {
      //     rec.debuglog();
      //   }
      //   if (globals.loggedInUser!.today.getActivity()! == null) {
      //     globals.currentSteps = 0;
      //   } else {
      //     globals.currentSteps =
      //         globals.loggedInUser!.today.getActivity()!.getSteps();

      //   print("$_sleepScore");
      //   print(sleepTime);
      //   print(wakeTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text('Signup'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _SignupFormKey,
            child: Column(
              // scrollDirection: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Please enter a new username",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                    onSaved: (String? value) {
                      newUsername = value;
                    },
                  ),
                ),
                Text(
                  "Please enter desired sleep amount in minutes",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      var intvalue = int.parse(value);
                      if (intvalue >= 24 * 60 || intvalue <= 0) {
                        return 'Please enter a value between 0 and 24';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Sleep Amount',
                    ),
                    onSaved: (String? value) {
                      print(value);
                      goalSleepAmount = int.parse(value!);
                      print("hi");
                    },
                  ),
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: BorderSide(width: 1, color: Colors.red),
                    ),
                    onPressed: () async {
                      goalWakeTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      showSimpleNotification(Text(
                          'Hope to sleep at ${goalWakeTime!.hour.toString().padLeft(2, '0')}:${goalWakeTime!.minute.toString().padLeft(2, '0')}!'));
                    },
                    child: Text('Enter Desired Wakeup Time')),
                SizedBox(height: 10),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        side: BorderSide(width: 1, color: Colors.black)),
                    onPressed: _handleSubmitted,
                    child: Text("Signup",
                        style: Theme.of(context).textTheme.titleMedium)),
              ],
            ),
          ),
        ));
  }
}
