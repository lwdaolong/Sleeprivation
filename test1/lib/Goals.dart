import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'dart:html';
import 'package:sane/sane.dart';


class Goals {
  late int desired_sleep_duration;
  late Time desired_wake_time;

  Goals(int desired_sleep_duration, Time desired_wake_time){
    this.desired_sleep_duration = desired_sleep_duration;
    this.desired_wake_time = desired_wake_time;

  }


  int getDesiredSleepDuration(){
    return this.desired_sleep_duration;
  }

  Time getDesiredWakeTime(){
    return this.desired_wake_time;
  }

  void setDesiredSleepDuration(int desired_sleep_duration){
    this.desired_sleep_duration = desired_sleep_duration;
  }

  void setDesiredWakeTime(Time desired_wake_time){
    this.desired_wake_time = desired_wake_time;
  }

  void print(){
    debugPrint(this.desired_sleep_duration.toString());
    debugPrint(this.desired_wake_time.toString());
  }


}