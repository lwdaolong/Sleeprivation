import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'dart:io';

Future<List<Map>> readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input);
  return map['users'];
}

class Sleep {
  late DateTime sleep_start; //Date Object
  late DateTime sleep_end;
  late int sleep_quality; //receives score 0-100
  late int sleep_duration; //receives time in minutes

  Sleep(DateTime sleep_start, DateTime sleep_end, int sleep_quality){//can't be asynchronous, so just initializes values to 0
    //this is a false constructor, please use the static method create() to return a Sleep object
    //built from a json file
    this.sleep_start = sleep_start;
    this.sleep_end = sleep_end;
    this.sleep_quality=sleep_quality;
    this.sleep_duration= sleep_start.difference(sleep_end).inMinutes.abs();
  }

  static Sleep parse(String start, String end, String quality){
    return Sleep(DateTime.parse(start), DateTime.parse(end), int.parse(quality));
  }

  static Future<Sleep> create(String filePath) async{
    var input = await File(filePath).readAsString();
    var map = jsonDecode(input);

    var sleep_instance = new Sleep(DateTime.now(),DateTime.now(),50);

    sleep_instance.sleep_start =DateTime.parse(map['bedtime_start']);
    sleep_instance.sleep_end =DateTime.parse(map['bedtime_end']);
    sleep_instance.sleep_quality=map['score'];
    sleep_instance.sleep_duration=map['duration'];

    return sleep_instance;

  }

  DateTime getSleepStart(){
    return this.sleep_start;
  }

  DateTime getSleepEnd(){
    return this.sleep_end;
  }

  int getSleepQuality(){
    return this.sleep_quality;
  }

  int getSleepDuration(){
    return this.sleep_duration;
  }

  String getSleepDurationInHours(){
    double tempduration = this.sleep_duration.toDouble();
    tempduration = tempduration/3600; //simplify to hours
    return tempduration.toString();
    //returning as string because realistically all calculations will use the default seconds
    //this is just used for pretty printing to UI or something
  }

  void printSleepDetails(){
    log("Sleep Start: " + this.sleep_start.toString());
    log("Sleep End: " + this.sleep_end.toString());
    log("Sleep Quality: " + this.sleep_quality.toString());
    log("Sleep Duration: " + this.sleep_duration.toString());

  }



}