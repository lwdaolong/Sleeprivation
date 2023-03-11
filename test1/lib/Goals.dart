import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';


class Goals {
  late int desired_sleep_duration;
  late TimeOfDay desired_wake_time; //will be using military time to establish AM or PM

  Goals(int desired_sleep_duration, TimeOfDay desired_wake_time){
    if(desired_sleep_duration <0 || desired_sleep_duration >23*60){
      this.desired_sleep_duration =8*60;//default to 8 hours if they try something funny
    }else{
      this.desired_sleep_duration = desired_sleep_duration;
    }
    this.desired_wake_time = desired_wake_time;

  }


  int getDesiredSleepDuration(){
    return this.desired_sleep_duration;
  }

  TimeOfDay getDesiredWakeTime(){
    return this.desired_wake_time;
  }

  void setDesiredSleepDuration(int desired_sleep_duration){
    if(desired_sleep_duration <0 || desired_sleep_duration >23*60){
      this.desired_sleep_duration =8*60;//default to 8 hours if they try something funny
    }else{
      this.desired_sleep_duration = desired_sleep_duration;
    }
  }

  void setDesiredWakeTime(TimeOfDay desired_wake_time){
    this.desired_wake_time = desired_wake_time;
  }

  void print(){
    debugPrint(this.desired_sleep_duration.toString());
    debugPrint(this.desired_wake_time.toString());
  }

  TimeOfDay parseTimeOfDayString(String time_str_rep){
    var splitstr = time_str_rep.split(":");
    var hours = int.parse(splitstr[0]);
    var minutes = int.parse(splitstr[1]);

    return TimeOfDay(hour: hours, minute: minutes);
  }


  Map<String, dynamic> toFirestore() {
    var temptimestr = desired_wake_time.hour.toString() +":"+desired_wake_time.minute.toString();

    return {
      if (desired_wake_time != null) "desired_wake_time": temptimestr,
      if (desired_sleep_duration != null) "desired_sleep_duration": desired_sleep_duration,
    };
  }

  factory Goals.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {

    //dumb but has to be here
    TimeOfDay parseTimeOfDayString(String time_str_rep){
      var splitstr = time_str_rep.split(":");
      var hours = int.parse(splitstr[0]);
      var minutes = int.parse(splitstr[1]);

      return TimeOfDay(hour: hours, minute: minutes);
    }


    final data = snapshot.data();
    return Goals(data?['desired_sleep_duration'],parseTimeOfDayString(data?['desired_wake_time']));
  }

}

/*
Future<Goals> fromFirestore() async {
    //TODO make modular
    final docRed = FirebaseFirestore.instance.collection("testing_new").doc("newGoal");
    var data;

    docRed.get().then(
            (DocumentSnapshot doc){
              log("reading snapshot from database");
              data = doc.data() as Map<String, dynamic>;

              log(data?['desired_sleep_duration']);
              log(data?['desired_wake_time']);

            }
    );


    //just in case other one doesn't return on error
    return Goals(data?['desired_sleep_duration'],parseTimeOfDayString(data?['desired_wake_time']));

  }
 */