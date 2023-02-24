// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:test1/Sleeprivation_Day.dart';
import 'package:test1/Goals.dart';
import 'package:test1/Caffeine.dart';
import 'package:test1/Sleep.dart';
import 'package:test1/Tiredness.dart';
import 'package:test1/Activity.dart';
import 'package:sane/sane.dart';


class Person {
  List logs;
  Goals goals;
  Sleeprivation_Day today;

  Person(Goals goals){
    this.logs = []; //ever evolving list of daily logs
    this.goals = goals; //established when personal profile is created
    this.today = Sleeprivation_Day();
  }

  List getLogs(){
    return this.logs;
  }

  Goals getGoals(){
    return this.goals;
  }

  Sleeprivation_Day getToday(){
    return today;
  }

  void setLogs(List logs){
    this.logs = logs;
  }

  void setGoals(Goals goals){
    this.goals=goals;
  }

  void setToday(Sleeprivation_Day today){
    this.today = today;
  }

  Time getRecommendedBedTime(){
    //TODO get time recommendation based on goals and recent logs
    return new Time(6,30);
    //find calculation of bed time, ideally from recent logs
    //use the returned time to schedule a notification
  }

  void getCaffeineRecomendation(){

    //TODO

    //based on some metric, schedule a caffeine recommendation x hours
    //before bedtime

    //if caffeine has already been consumed
    //rescind the notification

    //if no caffeine has been consumed
    //send a notfication for a last chance
  }

  void getActivityRecommendation(){
    //TODO

    //send notification near workout times
    //remind them that activity helps sleep
  }

  bool hadCaffeine(){
    return this.today.hadCaffeine();
  }

  bool didActivity(){
    return this.today.didActivity();
  }

  void addLog(Sleeprivation_Day day){
    this.logs.insert(0,day);
    //treats it like a stack, inserting at the top and looking at the most recetn
  }

  void setCaffeineToday(){
    this.today.setCaffeine(new Caffeine());
  }

  void setSleepToday(String filePath) async{
    var sleep = await Sleep.create(filePath);
    this.today.setSleep(sleep);
  }

  void setTirednessToday(int tiredscore){
    this.today.setTiredness(new Tiredness(tiredscore));
  }

  void setActivityToday(Activity activity){
    this.today.setActivity(activity);
  }


}


