import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';
import 'package:test1/Sleeprivation_Day.dart';
import 'package:test1/Goals.dart';
import 'package:test1/Caffeine.dart';
import 'package:test1/Sleep.dart';
import 'package:test1/Tiredness.dart';
import 'package:test1/Activity.dart';

import 'dart:developer';

import 'dart:math' hide log;

abstract class Recommendation {
  late final double loss;

  void debuglog();

  String getTitle();

  String getStringRecommendation();
}

class SleepRecommendationTuple extends Recommendation {
  final TimeOfDay rec_bedtime;
  final double loss;

  SleepRecommendationTuple(this.rec_bedtime, this.loss);

  void debuglog() {
    log("Sleep Recommendation");
    log(rec_bedtime.toString());
    log(loss.toString());
  }

  String getTitle() {
    return "Bed Time Improvement";
  }

  String getStringRecommendation() {
    String time =
        "${rec_bedtime!.hour.toString().padLeft(2, '0')}:${rec_bedtime!.minute.toString().padLeft(2, '0')}";
    return "Nice work lately! To improve your sleep, try to get to bed by " +
        time;
  }
}

class CaffeineRecommendationTuple extends Recommendation {
  final TimeOfDay rec_caffeine;
  final double loss;

  CaffeineRecommendationTuple(this.rec_caffeine, this.loss);

  void debuglog() {
    log("Caffeine Recommendation");
    log(rec_caffeine.toString());
    log(loss.toString());
  }

  String getTitle() {
    return "Caffeine Consumption Time";
  }

  String getStringRecommendation() {
    if (loss > 0) {
      String time =
          "${rec_caffeine!.hour.toString().padLeft(2, '0')}:${rec_caffeine!.minute.toString().padLeft(2, '0')}";
      return "Great job lately! To improve your sleep, try not to drink caffeine after " +
          time;
    } else {
      return "Keep up the good pace! You are consistently drinking caffeine long before your bed time!";
    }
  }
}

class StepReccomendationTuple extends Recommendation {
  final int rec_steps;
  final double loss;

  StepReccomendationTuple(this.rec_steps, this.loss);

  void debuglog() {
    log("Step Recommendation");
    log(rec_steps.toString());
    log(loss.toString());
  }

  String getTitle() {
    return "Activity Level";
  }

  String getStringRecommendation() {
    if (loss > 0) {
      return "Excellent job lately! To improve your sleep, try to walk ${rec_steps.toString()} steps today!";
    } else {
      return "Keep up the good pace! You are consistently walking about ${rec_steps.toString()} steps per day, over the recommended 8200 steps per day!";
    }
  }
}

class Personal_Model {
  late String name;
  late List logs;
  late Goals goals;
  late Sleeprivation_Day today;

  Personal_Model(String name, Goals goals) {
    this.name = name;
    this.logs = []; //ever evolving list of daily logs (Sleeprivation Day)
    this.goals = goals; //established when personal profile is created
    this.today = Sleeprivation_Day.getNewEmptyDay();
    //saveUserDetailsDB();
  }

  List getLogs() {
    return this.logs;
  }

  Goals getGoals() {
    return this.goals;
  }

  Sleeprivation_Day getToday() {
    return today;
  }

  void setLogs(List logs) {
    this.logs = logs;
  }

  void setGoals(Goals goals) {
    this.goals = goals;
  }

  void setToday(Sleeprivation_Day today) {
    this.today = today;
  }

  List<Recommendation> getRankedRecommendations() {
    List<Recommendation> unordered_recs = [
      getSleepRecommendationTuple(1),
      getCaffeineRecommendationTuple(1),
      getActivityRecommendation(25)
    ];

    Map map = {
      0: unordered_recs[0].loss,
      1: unordered_recs[1].loss,
      2: unordered_recs[2].loss
    };
    var sortedByValueMap = Map.fromEntries(
        map.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));
    List<Recommendation> ordered_recs = [];

    List indexorder =
        sortedByValueMap.entries.map((entry) => entry.key).toList();

    for (final index in indexorder) {
      ordered_recs.add(unordered_recs[index]);
    }
    return new List.from(ordered_recs.reversed);
  }

  //ENSURE USER IS LOADED/ logged in before this is called
  // Finds the K-nearest neighbors of the user's inputted sleep time duration goal
  SleepRecommendationTuple getSleepRecommendationTuple(double idealweight) {
    //if user is not logged in(debugging purposes, uncomment next line)
    //await retrieveLastWeekLogs();

    List<Sleep> sleepTuples = getSleepListFromLogs();
    Goals goal = this.goals;
    //just finds average of all of previous week's logs
    //combined with a couple (k) ideal logs to nudge the recommendation
    //so that their lifestyle change is not that different from their existing habits
    //e.g. gradual change

    //the loss/utlity is the distance between the vector created by the average recommendation
    //and the the ideal vector

    //add ideal vectors to logs to weight the average
    Sleep ideal = Sleep.fromGoal(goal);
    sleepTuples.add(ideal);
    sleepTuples.add(ideal);
    sleepTuples.add(ideal);

    //for the sake of this functions, sleeptimes will be treated on a 48 hour scale

    double bedtime_avg =
        0; //in minutes on a 48 hours military time scale - could swap AM and PM but lazy
    double duration_avg = 0;
    double quality_avg = 0;

    for (final t in sleepTuples) {
      bedtime_avg += getSpecialBedTimeMinuteRepresentation(t.getSleepStart());
      duration_avg += t.getSleepDuration();
      quality_avg += t.getSleepQuality();
    }

    //below three values represents a point in space, but the bedtime_avg is the actual recommendation
    bedtime_avg = bedtime_avg / sleepTuples.length;
    duration_avg = duration_avg / sleepTuples.length;
    quality_avg = quality_avg / sleepTuples.length;

    TimeOfDay bedtime_rec =
        getTimeOfDayFromSpecialMinuteRepresentation(bedtime_avg.toInt());

    //Calculate the loss of that recommendation
    final distance = sqrt(pow(goal.desired_sleep_duration - duration_avg, 2) +
        pow(
            getSpecialBedTimeMinuteRepresentationfromTimeOfDay(
                    goal.calculateAppropriateBedTime()) -
                bedtime_avg,
            2) +
        pow(100 - quality_avg, 2));

    return SleepRecommendationTuple(bedtime_rec, distance * idealweight);
  }

  int getSpecialBedTimeMinuteRepresentation(DateTime bedtime) {
    //helper function, don't use on its own
    int bedtime_minute_representation = 0;
    bedtime_minute_representation += bedtime.minute + bedtime.hour * 60;
    if (bedtime_minute_representation < 12 * 60) {
      //maybe fenceposting?
      bedtime_minute_representation += 24 * 60;
    }
    return bedtime_minute_representation;
  }

  int getSpecialBedTimeMinuteRepresentation2(DateTime? bedtime) {
    DateTime bedtime2;
    if (bedtime == null) {
      bedtime2 = DateTime.now();
    } else {
      bedtime2 = bedtime;
    }

    //helper function, don't use on its own
    int bedtime_minute_representation = 0;
    bedtime_minute_representation += (bedtime2.minute + bedtime2.hour * 60)!;
    return bedtime_minute_representation;
  }

  int getSpecialBedTimeMinuteRepresentation3(DateTime? bedtime) {
    DateTime bedtime2;
    if (bedtime == null) {
      bedtime2 = DateTime.now();
    } else {
      bedtime2 = bedtime;
    }

    //helper function, don't use on its own
    int bedtime_minute_representation = 0;
    bedtime_minute_representation += (bedtime2.minute + bedtime2.hour * 60)!;
    if (bedtime_minute_representation < 12 * 60) {
      //maybe fenceposting?
      bedtime_minute_representation += 24 * 60;
    }
    return bedtime_minute_representation;
  }

  int getSpecialBedTimeMinuteRepresentationfromTimeOfDay(TimeOfDay bedtime) {
    //helper function, don't use on its own
    int bedtime_minute_representation = 0;
    bedtime_minute_representation += bedtime.minute + bedtime.hour * 60;
    if (bedtime_minute_representation < 12 * 60) {
      //maybe fenceposting?
      bedtime_minute_representation += 24 * 60;
    }
    return bedtime_minute_representation;
  }

  TimeOfDay getTimeOfDayFromSpecialMinuteRepresentation(
      int minute_representation) {
    int military_time;

    if (minute_representation > 24 * 60) {
      military_time = minute_representation - 24 * 60;
    } else {
      military_time = minute_representation;
    }
    int hours = (military_time / 60).toInt();
    int minutes = military_time % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  DateTime getDateTimeFromTimeOfDay(TimeOfDay time_representation) {
    DateTime now = DateTime.now();
    return new DateTime(now.year, now.month, now.day, time_representation.hour,
        time_representation.minute);
  }

  int timeOfDaytoInt(TimeOfDay myTime) {
    return myTime.hour * 60 + myTime.minute;
  }

  int intsToTimeInt(int hours, int minutes) {
    return hours * 60 + minutes;
  }

  TimeOfDay minutesToTimeOfDay(int timeInt) {
    int hours = (timeInt / 60).toInt();
    int minutes = timeInt % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

//duration should be in the form of an int in minutes required to sleep,
//maybe make another helper function that turns a duration in the form of hours/minutes into one singular int of minutes
  TimeOfDay calculateAppropriateBedTime(TimeOfDay wakeup, int duration) {
    //DO NOT USE THIS, JUST HELPER METHOD
    int wakeupint = timeOfDaytoInt(wakeup);
    int bedtime = wakeupint - duration;

    if (bedtime >= 0) {
      return minutesToTimeOfDay(bedtime);
    } else {
      int yesterday = 24 * 60; //e.g. midnight in minutes
      return minutesToTimeOfDay(yesterday + bedtime);
    }
  }

  CaffeineRecommendationTuple getCaffeineRecommendationTuple(int idealweight) {
    Caffeine finalcaftime = Caffeine.fromGoal(this.goals);
    List<Caffeine>? caflist = getCaffeineListFromLogs();

    //add ideal vectors to logs to weight the average
    caflist.add(finalcaftime);
    caflist.add(finalcaftime);
    caflist.add(finalcaftime);

    //for the sake of this functions, sleeptimes will be treated on a 48 hour scale

    double caftime_avg = 0;

    //if caffeine has already been consumed
    //rescind the notification

    int caffinalminuterep =
        getSpecialBedTimeMinuteRepresentation2(finalcaftime.caffeine_time);

    /*
    int caf_time_instance = getSpecialBedTimeMinuteRepresentation2(t.getCaffeineTime());
      if(caf_time_instance >= caffinalminuterep){
        log(caf_time_instance.toString());
        caftime_avg += caf_time_instance;
        i +=1;
      }
     */
    for (final t in caflist) {
      //check if they drink caffeine before the suggested time
      caftime_avg +=
          getSpecialBedTimeMinuteRepresentation2(t.getCaffeineTime());
    }

    //below three values represents a point in space, but the bedtime_avg is the actual recommendation
    caftime_avg = caftime_avg / caflist.length;

    TimeOfDay caftime_rec =
        getTimeOfDayFromSpecialMinuteRepresentation(caftime_avg.toInt());

    //Calculate the loss of that recommendation
    var distance = 0.0;
    var finalcaftimeminuterep =
        getSpecialBedTimeMinuteRepresentation3(finalcaftime.getCaffeineTime());

    if (caftime_avg > finalcaftimeminuterep) {
      distance = (finalcaftimeminuterep - caftime_avg).abs();
    }

    return CaffeineRecommendationTuple(caftime_rec, distance * idealweight);

    //T WHEN READING THE RECOMMENDATION, IF THE RECOMMENDATION IS EQUAL TO THE IDEAL
    //T THEN CHANGE THE WORDING TO "IF YOU WANT TO" DRINK CAFFEINE, DRINK BY ideal time
    //T AND IF RECOMMENDATION LOSS IS HIGH, then change to "Drink caffeine by this time"
    //T SO THAT RECS ARE PERSONALIZED TO HABITS

    //TODO WHEN PRINTING TO FRONT END, DO ANOTHER CHECK TO SEE IF AVERAGE
    //TODO CAFFEINE ALIGNS WITH USER GOALS
    //TODO IF AVERAGE IS ALIGNED THEN TELL USER GOOD JOB: HERES YOUR AVERAGE CAFFEINE TIME, KEEP DRINKKING BEFORE 3:00 PM FOR GOOD REST
    //TODO OTHERWISE, RECOMMEND USER CAFFEINE TIME SLIGHTLY NUDGED
  }

  //maybe return a tuple of the actual recommendation and a measurable loss/utility)
  StepReccomendationTuple getActivityRecommendation(double idealweight) {
    List<Activity> actlist = getActivityListFromLogs();

    const int idealsteps = 8200;
    Activity ideal_activity = Activity(idealsteps);

    actlist.add(ideal_activity);

    double step_avg = 0;

    for (final t in actlist) {
      step_avg += t.getSteps();
    }

    step_avg = step_avg / actlist.length;

    if (step_avg < idealsteps) {
      //if you are NOT getting enough steps per day
      //weigh the distance invertly from avg steps to
      double distance = idealsteps / (1 + step_avg);

      //double distance = (step_avg- idealsteps).abs();
      return new StepReccomendationTuple(
          step_avg.toInt(), distance * idealweight);
    } //else (if you are getting enough steps per day, 0 loss)
    return new StepReccomendationTuple(step_avg.toInt(), 0);
    //send notification near workout times
    //Research shows 30 minuts of activity per day
    //and at least 5,000 steps a day leads to healthy lifestyle
    //remind them that activity helps sleep
  }

  bool hadCaffeine() {
    return this.today.hadCaffeine();
  }

  bool didActivity() {
    return this.today.didActivity();
  }

  void addLog(Sleeprivation_Day day) {
    this.logs.insert(0, day);
    //treats it like a stack, inserting at the top and looking at the most recetn
  }

  void setCaffeineToday() {
    this.today.setCaffeine(new Caffeine());
  }

  void setSleepToday(String filePath) async {
    var sleep = await Sleep.create(filePath);
    this.today.setSleep(sleep);
  }

  void setTirednessToday(int tiredscore) {
    this.today.setTiredness(new Tiredness(tiredscore));
  }

  void setActivityToday(Activity activity) {
    this.today.setActivity(activity);
  }

  static void getUserFromDB(String username) {
    //THIS SHOULD NOT BE USED FOR ANYTHING BESIDES DEBUGGING
    //JUST QUERIES AND PRINTS DATA ABOUT A USER BY USERNAME
    //CRASHES WHEN USER DOES NOT EXIST
    final goal_ref = FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('Goals');

    final goal_query = goal_ref.get().then(
      (querySnapshot) {
        log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          log('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => log("Error completing: $e"),
    );

    final curr_day_ref = FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('Curr_Day');

    final curr_day_query = curr_day_ref.get().then(
      (querySnapshot) {
        log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          log('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => log("Error completing: $e"),
    );

    final day_logs_ref = FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('Day_Logs');

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

  void getThisUserFromDB() {
    final user_ref = FirebaseFirestore.instance
        .collection('users')
        .doc(this.name)
        .collection('Curr_Day');

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
  Future<void> setGoalDebug(String username, Goals newgoal) async {
    //set reference
    final goalref = FirebaseFirestore.instance
        .collection("users")
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
  Future<void> setGoal(Goals newgoal) async {
    //set reference
    final goalref = FirebaseFirestore.instance
        .collection("users")
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
  Future<void> updateGoalsfromDB() async {
    //set reference
    final goalref = FirebaseFirestore.instance
        .collection("users")
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

  Future<void> updateGoalsfromDBDebug(String username) async {
    //set reference
    final goalref = FirebaseFirestore.instance
        .collection("users")
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

  Future<void> setTodayDB(Sleeprivation_Day newday) async {
    //setes today in memory and database
    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
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

  Future<void> setSleeprivationDayinLogsDB(Sleeprivation_Day newday) async {
    //updates a given user's 'logged' day into the 'day logs' collection in database
    //used as helper function in a for loop to load all logged days into database
    //okay to use to overwrite logs
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted_date = formatter.format(newday.date
        as DateTime); //ensures entries are just date, time not included

    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .doc(formatted_date)
        .withConverter(
          fromFirestore: Sleeprivation_Day.fromFirestore,
          toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
        );

    //update DB
    await todayref.set(newday);
  }

  Future<void> updateTodayFromDB() async {
    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
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

  // retrieve all logs, beware no error checking
  Future<void> retrieveAllLogsDB() async {
    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .withConverter(
          fromFirestore: Sleeprivation_Day.fromFirestore,
          toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
        );

    var newdaydata = await todayref.get();

    //empty logs before re-instantiating from database
    this.logs = [];
    for (var docSnapshot in newdaydata.docs) {
      Sleeprivation_Day newday = docSnapshot.data() as Sleeprivation_Day;
      this.logs.add(newday);
    }
  }

  //just do like all logs, but limit to 7 and add/don't add to logs based on query
  Future<void> retrieveLastWeekLogs() async {
    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .withConverter(
          fromFirestore: Sleeprivation_Day.fromFirestore,
          toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
        );

    var newdaydata = await todayref.get();

    //empty logs before re-instantiating from database
    this.logs = [];
    for (var docSnapshot in newdaydata.docs) {
      Sleeprivation_Day newday = docSnapshot.data() as Sleeprivation_Day;
      int? days_between_dates = newday.date?.difference(DateTime.now()).inDays;
      if (days_between_dates != null &&
          days_between_dates >= -7 &&
          days_between_dates <= -1) {
        this.logs.add(newday);

        //log(days_between_dates.toString());
        //newday.debuglog();
      }
    }
  }
  //potentially set all logs? could be dangerous but useful for debugging

  // get a list of JUST sleep objects from logs
  List<Sleep> getSleepListFromLogs() {
    List<Sleep> sleeplist = [];
    for (final t in this.logs) {
      sleeplist.add(t.getSleep());
    }

    return sleeplist;
  }

  // get a list of JUST Caffeine objects from logs
  List<Caffeine> getCaffeineListFromLogs() {
    List<Caffeine> caflist = [];
    for (final t in this.logs) {
      caflist.add(t.getCaffeine());
    }

    return caflist;
  }

  // get a list of JUST Activity objects from logs
  List<Activity> getActivityListFromLogs() {
    List<Activity> actlist = [];
    for (final t in this.logs) {
      Activity tempact;
      var returnedAct = t.getActivity();
      if (returnedAct == null) {
        tempact = new Activity(0);
      } else {
        tempact = returnedAct;
      }
      actlist.add(tempact);
    }
    return actlist;
  }

  Future<void> pushTodayIntoLogsDB() async {
    //push current day into logs array and into DB logs array

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted_date = formatter.format(this.today.date
        as DateTime); //ensures entries are just date, time not included

    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .doc(formatted_date)
        .withConverter(
          fromFirestore: Sleeprivation_Day.fromFirestore,
          toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
        );

    //update goal DB
    await todayref.set(this.today);

    this.logs.add(this.today);
    //Maybe set today to a null day after to rest?
  }

  Future<void> pushDayIntoLogsDB(Sleeprivation_Day day) async {
    //push given Sleeprivation Day day into logs array and into DB logs array

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted_date = formatter.format(day.date
        as DateTime); //ensures entries are just date, time not included

    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .doc(formatted_date)
        .withConverter(
          fromFirestore: Sleeprivation_Day.fromFirestore,
          toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
        );

    //update goal DB
    await todayref.set(day);

    this.logs.add(day);
    //Maybe set today to a null day after to rest?
  }

  static Future<bool> checkForUser(String username) async {
    //use this at login
    //if return false, use the normal constructor PersonalModel()
    //if return true, user already exists, use instantiateUserFromDB
    var usersRef = FirebaseFirestore.instance.collection('users').doc(username);
    var usersnapshot = await usersRef.get();
    if (usersnapshot.exists) {
      return true;
    }
    return false;
  }

  Future<void> saveUserDetailsDB() async {
    //push ALL user data into DB
    //probably rarely needed, but save entire Personal model to DB
    //would rather call saves on specific attributes when needed
    //expensive to save model

    final data = {"exists": true};

    FirebaseFirestore.instance
        .collection("users")
        .doc(this.name)
        .set(data, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));

    //save goals
    setGoal(this.goals);
    //save today
    setTodayDB(this.today);
    //for each log in logs, save log
    for (var day in this.logs) {
      //loads each given day within 'logs' to database one at a time
      setSleeprivationDayinLogsDB(day);
    }
  }

  void debuglog() {
    log(this.name);
    this.goals.print();
    log("Current Day:");
    this.today.debuglog();
    for (var value in this.logs) {
      //print details for each day in a users loaded logs
      log("New Day:");
      value.debuglog();
    }
  }

  //ONLY CALL THIS METHOD ONCE THE USER IS KNOWN TO BE IN THE DATABASE
  //WILL CRASH IF USER IS NOT IN DATABASE
  static Future<Personal_Model> loadUserFromDB(String username) async {
    Goals tempgoals = new Goals(8 * 60, TimeOfDay(hour: 8, minute: 30));
    Personal_Model temp = Personal_Model(username, tempgoals);
    //manually update personal model with methods

    //load goals
    await temp.updateGoalsfromDB();

    //load Today
    await temp.updateTodayFromDB();

    //load Logs
    //await temp.retrieveAllLogsDB();
    await temp.retrieveLastWeekLogs();

    //save and return
    return temp;
  }

  //use this method to log user in
  static Future<Personal_Model?> loginUser(String username) async {
    if (await Personal_Model.checkForUser(username)) {
      return await Personal_Model.loadUserFromDB(username);
    } else {
      log("User Does Not Exist");
      return null;
    }
  }

  static Future<Personal_Model?> createNewUser(
      String username, Goals goals) async {
    //creates a new user and returns an object instance
    //also saves new user profile to database
    //ONLY CALL THIS IF USERNAME IS NOT ALREADY IN APP
    //WILL OVERWRITE EXISTING USER IF USED CALLOUSLY

    if (await Personal_Model.checkForUser(username) == false) {
      Personal_Model newuser = new Personal_Model(username, goals);
      newuser.saveUserDetailsDB();
      return newuser;
    }
    return null;
  }

  Future<Sleeprivation_Day> retrieveYesterday() async {
    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .withConverter(
          fromFirestore: Sleeprivation_Day.fromFirestore,
          toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
        );

    var newdaydata = await todayref.get();

    Sleeprivation_Day closestday = Sleeprivation_Day.getNewEmptyDay();
    closestday.setDate(new DateTime(0000)); //really long time ago

    //empty logs before re-instantiating from database
    for (var docSnapshot in newdaydata.docs) {
      Sleeprivation_Day newday = docSnapshot.data() as Sleeprivation_Day;
      if (newday.getDate() != null && closestday.getDate() != null) {
        String s = newday.getDate().toString();
        DateTime temp = DateTime.parse(s);
        if (temp.isAfter(closestday.getDate()!)) {
          closestday = newday;
        }
      }
    }
    return closestday;
  }

  Future<List<Sleeprivation_Day>> getAllLogsDB() async {
    //set reference
    final todayref = FirebaseFirestore.instance
        .collection("users")
        .doc(this.name)
        .collection("Day_Logs")
        .withConverter(
          fromFirestore: Sleeprivation_Day.fromFirestore,
          toFirestore: (Sleeprivation_Day tempday, _) => tempday.toFirestore(),
        );

    var newdaydata = await todayref.get();

    //empty logs before re-instantiating from database
    List<Sleeprivation_Day> temp = [];
    for (var docSnapshot in newdaydata.docs) {
      Sleeprivation_Day newday = docSnapshot.data() as Sleeprivation_Day;
      temp.insert(0, newday);
    }

    return temp;
  }
}
