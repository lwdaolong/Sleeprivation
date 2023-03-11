
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:test1/Caffeine.dart';
import 'package:test1/Sleep.dart';
import 'package:test1/Tiredness.dart';
import 'package:test1/Activity.dart';
import 'firebase_options.dart';

class Sleeprivation_Day {
  late DateTime date;
  late Caffeine caffeine; //maybe change to list for multiple caffeine intakes?
  late Sleep sleep;
  late Tiredness tiredness;
  late Activity activity;

  Sleeprivation_Day(){
    //because a given day will be updated dynamically, the default class sets everything to null
    this.date = DateTime.now();
    this.caffeine = new Caffeine();
    this.sleep = new Sleep();
    this.tiredness = new Tiredness(100);
    this.activity = new Activity();

  }

  void setDate(DateTime date){
    this.date = date;
  }

  DateTime getDate(){
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

  Caffeine getCaffeine(){
    return this.caffeine;
  }

  Sleep getSleep(){
    return this.sleep;
  }

  Tiredness getTiredness(){
    return this.tiredness;
  }

  Activity getActivity(){
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

}