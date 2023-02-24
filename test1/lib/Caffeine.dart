import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'dart:html';


class Caffeine {
  late DateTime caffeine_time;

  Caffeine(){
    this.caffeine_time = DateTime.now();

  }

  DateTime getCaffeineTime(){
    return caffeine_time;
  }

  void setCaffeineTime(DateTime caffeine_time){
    this.caffeine_time = caffeine_time;
  }

  void print(){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(this.caffeine_time);
    debugPrint(formatted);
  }


}