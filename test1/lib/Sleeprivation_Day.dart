
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:test1/Caffeine.dart';
import 'package:test1/Sleep.dart';
import 'package:test1/Tiredness.dart';
import 'package:test1/Activity.dart';
import 'firebase_options.dart';

class Sleeprivation_Day {
  ///WARNING ALL ATTRIBUTES CAN AND WILL RETURN NULL, NULL CHECK EVERY USE
  late DateTime? date;
  late Caffeine? caffeine; //maybe change to list for multiple caffeine intakes?
  late Sleep? sleep;
  late Tiredness? tiredness;
  late Activity? activity;

  Sleeprivation_Day(DateTime day, Caffeine? caffeine, Sleep? sleep, Tiredness? tiredness, Activity? activity){
    //because a given day will be updated dynamically, the default class sets everything to null
    this.date = day;
    this.caffeine = caffeine;
    this.sleep = sleep;
    this.tiredness = tiredness;
    this.activity = activity;

  }

  static Sleeprivation_Day getNewEmptyDay(){
    DateTime now = new DateTime.now();
    DateTime curr_date = new DateTime(now.year,now.month,now.day); //to represent a given date

    return new Sleeprivation_Day(curr_date, null, null, null, null);
  }

  void setDate(DateTime date){
    this.date = date;
  }

  DateTime? getDate(){
    return this.date;
  }

  void setCaffeine(Caffeine caffeine){
    this.caffeine = caffeine;
  }

  void setSleep(Sleep sleep){
    this.sleep = sleep;
  }

  void setTiredness(Tiredness tiredness){
    this.tiredness = tiredness;
  }

  void setActivity(Activity activity){
    this.activity = activity;
  }

  Caffeine? getCaffeine(){
    return this.caffeine;
  }

  Sleep? getSleep(){
    return this.sleep;
  }

  Tiredness? getTiredness(){
    return this.tiredness;
  }

  Activity? getActivity(){
    return this.activity;
  }

  bool hadCaffeine(){
    //used when monitoring to send notificaiton to have caffeine
    if(this.caffeine == null){
      return false;
    }
    return true;
  }

  bool didActivity(){
    //used when monitoring to send notificaiton to exercise
    if(this.activity == null){
      return false;
    }
    return true;
  }

  Map<String, dynamic> toFirestore() {

    return {
      if (date != null) "date": date,
      "caffeine": caffeine?.getCaffeineTime(),
      "sleep_start": sleep?.getSleepStart(),
      "sleep_end": sleep?.getSleepEnd(),
      "sleep_duration": sleep?.getSleepDuration(),
      "sleep_quality": sleep?.getSleepQuality(),
      "tiredness": tiredness?.getTiredScore(),
      "activity": activity?.getSteps(),
    };
  }

  factory Sleeprivation_Day.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {

    final data = snapshot.data();


    DateTime date_instance = (data?['date'].toDate());
    Caffeine caffeine_instance = new Caffeine(caffeine_time: data?['caffeine'].toDate());
    Sleep sleep_instance = new Sleep(data?['sleep_start'].toDate(), data?['sleep_end'].toDate(),data?['sleep_quality']);
    Tiredness tiredness_instance = new Tiredness(data?['tiredness']);
    Activity activity_instance = new Activity(data?['activity']);

    return Sleeprivation_Day(date_instance,caffeine_instance,sleep_instance,tiredness_instance,activity_instance);
  }

  void debuglog(){
    log(this.date.toString());
    this.caffeine?.print('o');
    this.sleep?.printSleepDetails();
    this.tiredness?.print();
    this.activity?.print();

  }

}