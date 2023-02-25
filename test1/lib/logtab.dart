import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class LogTab extends StatefulWidget {
  const LogTab({super.key});

  // List<String> logs = <String>['bob', 'joe'];
  @override
  State<LogTab> createState() => _MyLogTab();
}

class _MyLogTab extends State<LogTab> {
  List<int> logs = [90, 92, 80, 29, 97];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        return Card(
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
                      Text('February 23, 2023',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text('Sleep Score: ${logs[index]}/100',
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text('Sleep Time: 11:00 PM',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text('Wake Time: 8:00 AM',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text('Caffeine Intake: 8:00 PM',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text('Number of Steps: 3000',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ])),
          ),
        );
      },
      // scrollDirection: Axis.vertical,
    );
  }
}
