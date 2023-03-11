
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

import 'dart:developer';


class Personal_Model {
  late String name;
  late List logs;
  late Goals goals;
  late Sleeprivation_Day today;

  Personal_Model(String name, Goals goals){
    this.name = name;
    this.logs = []; //ever evolving list of daily logs (Sleeprivation Day)
    this.goals = goals; //established when personal profile is created
    this.today = Sleeprivation_Day.getNewEmptyDay();
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

  TimeOfDay getRecommendedBedTime(){
    //TODO get time recommendation based on goals and recent logs
    return new TimeOfDay(hour: 6,minute: 30);
    //find calculation of bed time, ideally from recent logs
    //use the returned time to schedule a notification

    //subtract wake time by desired_duration
    //if output is positive, return,
    //if positive is negative, add the negative to 24 (12 AM midnight) to get a positive number
    //this probably breaks if your desired sleep time is more than 24 hours, make goal so it is not negative or more than 24 hours

    //default behaviour, should implement differntly based on most recent sleep times or log list length

  }

  void getCaffeineRecomendation(){
    //based on metric from @source, should not consume caffeine X hours before bedtime
    //based on usual consumption in combination with general recommendation
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

  static void getUserFromDB(String username){
    final goal_ref = FirebaseFirestore.instance.collection('users').doc(username).collection('Goals');

    final goal_query = goal_ref.get().then(
          (querySnapshot) {
        log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          log('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => log("Error completing: $e"),
    );

    final curr_day_ref = FirebaseFirestore.instance.collection('users').doc(username).collection('Curr_Day');

    final curr_day_query = curr_day_ref.get().then(
          (querySnapshot) {
        log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          log('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => log("Error completing: $e"),
    );

    final day_logs_ref = FirebaseFirestore.instance.collection('users').doc(username).collection('Day_Logs');

    final day_logs_query = day_logs_ref.get().then(
          (querySnapshot) {
        log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          log('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => log("Error completing: $e"),
    );

  }

  void getThisUserFromDB(){
    final user_ref = FirebaseFirestore.instance.collection('users').doc(this.name).collection('Curr_Day');

    final query = user_ref.get().then(
          (querySnapshot) {
        log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          log('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => log("Error completing: $e"),
    );

  }

  //sets Goal and pushes to DB
  Future<void> setGoalDebug(String username, Goals newgoal) async{
    
    //set reference
    final goalref = FirebaseFirestore.instance.collection("users")
        .doc(username)
        .collection("Goals")
        .doc("user_goals")
        .withConverter(
      fromFirestore: Goals.fromFirestore,
      toFirestore: (Goals tempgoal, _) => tempgoal.toFirestore(),
    );

    //update goal DB
    await goalref.set(newgoal);

    this.goals = newgoal;
  }

  //simultaneously sets Goal in memory and Database
  Future<void> setGoal( Goals newgoal) async{

    //set reference
    final goalref = FirebaseFirestore.instance.collection("users")
        .doc(this.name)
        .collection("Goals")
        .doc("user_goals")
        .withConverter(
      fromFirestore: Goals.fromFirestore,
      toFirestore: (Goals tempgoal, _) => tempgoal.toFirestore(),
    );

    //update goal DB
    await goalref.set(newgoal);

    this.goals = newgoal;
  }

  //Look's up this Personal Model's instance's name
  // in the database, and updates the 'goals' attribute
  // if 'name' not found in database, crash will occur
  Future<void> updateGoalsfromDB() async{
    //set reference
    final goalref = FirebaseFirestore.instance.collection("users")
        .doc(this.name)
        .collection("Goals")
        .doc("user_goals")
        .withConverter(
      fromFirestore: Goals.fromFirestore,
      toFirestore: (Goals tempgoal, _) => tempgoal.toFirestore(),
    );

    var newgoaldata = await goalref.get();
    Goals newgoal = newgoaldata.data() as Goals;
    this.goals = newgoal;

  }

  Future<void> updateGoalsfromDBDebug(String username) async{
    //set reference
    final goalref = FirebaseFirestore.instance.collection("users")
        .doc(username)
        .collection("Goals")
        .doc("user_goals")
        .withConverter(
      fromFirestore: Goals.fromFirestore,
      toFirestore: (Goals tempgoal, _) => tempgoal.toFirestore(),
    );

    var newgoaldata = await goalref.get();
    Goals newgoal = newgoaldata.data() as Goals;
    this.goals = newgoal;

  }

  Future<void> setTodayDB( Sleeprivation_Day newday) async{

    //set reference
    final todayref = FirebaseFirestore.instance.collection("users")
        .doc(this.name)
        .collection("Curr_Day")
        .doc("today")
        .withConverter(
      fromFirestore: Sleeprivation_Day.fromFirestore,
      toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
    );

    //update goal DB
    await todayref.set(newday);

    this.today = newday;
  }

  Future<void> updateTodayFromDB() async{
    //set reference
    final todayref = FirebaseFirestore.instance.collection("users")
        .doc(this.name)
        .collection("Curr_Day")
        .doc("today")
        .withConverter(
      fromFirestore: Sleeprivation_Day.fromFirestore,
      toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
    );

    var newdaydata = await todayref.get();
    Sleeprivation_Day newday = newdaydata.data() as Sleeprivation_Day;
    this.today = newday;

  }


  //TODO retrieve all logs
  Future<void> retrieveAllLogsDB() async{
    //set reference
    final todayref = FirebaseFirestore.instance.collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .withConverter(
      fromFirestore: Sleeprivation_Day.fromFirestore,
      toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
    );

    var newdaydata = await todayref.get();

    //empty logs before re-instantiating from database
    this.logs =[];
    for (var docSnapshot in newdaydata.docs){
      Sleeprivation_Day newday = docSnapshot.data() as Sleeprivation_Day;
      this.logs.add(newday);
    }

  }


  //TODO push current day into logs and into DB
  Future<void> pushTodayIntoLogsDB() async{

    //set reference
    final todayref = FirebaseFirestore.instance.collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .doc(this.today.date.toString())
        .withConverter(
      fromFirestore: Sleeprivation_Day.fromFirestore,
      toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
    );

    //update goal DB
    await todayref.set(this.today);

    this.logs.add(this.today);
    //Maybe set today to a null day after to rest?
  }

  //TODO retrieve 7 most recent logs
  //just do like all logs, but limit to 7 and add/don't add to logs based on query

  //potentially set all logs? could be dangerous but useful for debugging



  //TODO create new User with Goals
  Future<void> createNewUserDB() async{
    //create intiial user collection based on username
  }

  //TODO push user data into DB
  Future<void> saveUserDetailsDB() async{
    //probably rarely needed, but save entire Personal model to DB
    //would rather call saves on specific attributes when needed
    //expensive to save model
  }

  //TODO instantiate user from DB
  Future<void> instantiateUserFromDB() async{
    //looks for collection of this.name
    //instantiates attributes based on collection in DB
  }





}


