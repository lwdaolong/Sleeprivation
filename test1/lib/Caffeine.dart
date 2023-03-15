import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
//import 'dart:html';
import 'package:test1/Goals.dart';


class Caffeine {
  late DateTime? caffeine_time; //assumes just one serving of caffeine, auto replaced by latest time you consumed

  Caffeine({this.caffeine_time});

  static Caffeine parse(String s){ //assuming s is a real DateTime String
    DateTime parseDate = DateTime.parse(s);
    return Caffeine(caffeine_time: parseDate);
  }

  DateTime? getCaffeineTime(){
    return this.caffeine_time;
  }


  void setCaffeineTime(DateTime caffeine_time){
    this.caffeine_time = caffeine_time;
  }

  void print(String s){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(this.caffeine_time as DateTime);
    //log(formatted);
    log(this.caffeine_time.toString());
  }

  void addCaffeineToDB(){ //used for debugging ONLY

    final caffeine_log = <String, Timestamp>{
      "caffeine_timestamp": Timestamp.fromDate(DateTime.now()),
    };

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now); //ensures entries are just date, time not included

    FirebaseFirestore.instance
        .collection("caffeine")
        .doc(formatted)
        .set(caffeine_log)
        .onError((e, _) => print("Error writing document: $e"));

    log("caffeine added");

    //assumes timestamp is current timestamp
    /*
    FirebaseFirestore.instance
        .collection('Caffeine')
        .add({'caffeine_timestamp': Timestamp.fromDate(DateTime.now())});
     */


  }


  //used for debugging ONLY
  void getAllCaffeine(){ //doc_id format should be in form of "yyyy-MM-dd"
    final caffeineref = FirebaseFirestore.instance.collection("caffeine");

    final query = caffeineref.get().then(
          (querySnapshot) {
        log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          log('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => log("Error completing: $e"),
    );


  }

  factory Caffeine.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Caffeine(
      caffeine_time: data?['caffeine_time'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (caffeine_time != null) "caffeine_time": caffeine_time,
    };
  }

  static Caffeine fromGoal(Goals goal){
    //an ideal caffeine time according to Google
    //is no less than 6 hours before bedtime
    //we will be using this metric to calculate a timestamp for the
    //LAST time you drink caffeine

    TimeOfDay? bt = goal.calculateAppropriateBedTime();

    //scuffed
    DateTime now = DateTime.now();
    DateTime bedtime = DateTime(now.year,now.month,now.day,bt.hour,bt.minute);
    DateTime caffeine_final_time = bedtime.add(Duration(hours: -6));

    return new Caffeine(caffeine_time: caffeine_final_time);
  }


}