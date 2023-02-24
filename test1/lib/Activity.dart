import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'dart:html';


class Activity {
  //will implement later, in the meantime just a dummy data class
  //don't know if we want this to be a live data feed, and how exactly we will pull from it
  //do we want timestamps of large chunks of exercise/steps?
  //do we just want to log total exercise for the day and reflect on it the next day?
  //idk
  late int steps;

  Activity(){
    this.steps =0;

  }

  int getSteps(){
    return this.steps;
  }

  void setSteps(steps){
    this.steps = steps;
  }


  void print(){
    debugPrint(this.steps.toString());
  }


}