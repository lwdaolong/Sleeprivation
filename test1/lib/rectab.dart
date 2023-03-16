import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'Activity.dart';
import 'firebase_options.dart';
import 'package:overlay_support/overlay_support.dart';

import 'globals.dart' as globals;
import 'logtab.dart' as logs;
import 'Personal_Model.dart';

class RecTab extends StatefulWidget {
  const RecTab({super.key});

  @override
  State<RecTab> createState() => _MyRecTab();
}

class _MyRecTab extends State<RecTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today's Sleep Score:",
                      style: Theme.of(context).textTheme.titleLarge),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 80.0, 8.0),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.star),
                            Text(
                                "${(globals.allLogs![0].getSleep()!.sleep_quality / 10).toInt().toString()}/10",
                                style: Theme.of(context).textTheme.titleLarge),
                          ])),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        side: BorderSide(width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          Text('Log Caffeine',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                      onPressed: () {
                        showSimpleNotification(
                          Text("Logged 1 serving of caffeine!"),
                        );
                      }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      'Sleep: ${logs.getDateWithoutMilliSeconds(globals.allLogs![0].getSleep()!.sleep_start).toString()}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                      'Wake: ${logs.getDateWithoutMilliSeconds(globals.allLogs![0].getSleep()!.sleep_end).toString()}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text('Last Caffeine: ${globals.lastCaffeine}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text('Number of Steps: ${globals.currentSteps}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: globals.recCards!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
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
                              Text('Recommendation Priority ${index + 1}',
                                  style: Theme.of(context).textTheme.bodySmall),
                              Text('${globals.recCards![index].getTitle()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              Text(
                                  '${globals.recCards![index].getStringRecommendation()}',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ])),
                  ),
                ),
              );
            },
            // scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }
}
