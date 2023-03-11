import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';


class Activity {
  //will implement later, in the meantime just a dummy data class
  //don't know if we want this to be a live data feed, and how exactly we will pull from it
  //do we want timestamps of large chunks of exercise/steps?
  //do we just want to log total exercise for the day and reflect on it the next day?
  //idk
  late int steps;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  Activity(int steps){
    this.steps =steps;

  }

  static Activity parse(String steps){
    return Activity(int.parse(steps));
  }

  int getSteps(){
    return this.steps;
  }

  //can't really test pedometer on emulator effectively,
  //can spoof live data by setting random incrementing numbers
  void setSteps(steps){
    this.steps = steps;
  }


  void print(){
    debugPrint(this.steps.toString());
  }


  void onStepCount(StepCount event) {
    /// Handle step count changed
    this.steps = event.steps;
    DateTime timeStamp = event.timeStamp;
    log(this.steps.toString());
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    /// Handle status changed
    String status = event.status;
    DateTime timeStamp = event.timeStamp;
  }

  void onPedestrianStatusError(error) {
    /// Handle the error
  }

  void onStepCountError(error) {
    /// Handle the error
  }

  //only call when is current day activity, all previous days should
  //be read only
  Future<void> initPlatformState() async {
    /// Init streams
    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
    _stepCountStream = await Pedometer.stepCountStream;

    /// Listen to streams and handle errors
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }

}