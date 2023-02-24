import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'dart:html';


class Tiredness {
  late int tired_score;

  Tiredness(int tired_score){
    if(tired_score >=0 && tired_score <=10){
      this.tired_score = tired_score;
    }else{

      this.tired_score =-1;
      //indicate error
    }
  }

  int getTiredScore(){
    return this.tired_score;
  }

  void setTiredScore(int tired_score){
    if(tired_score >=0 && tired_score <=10){
      this.tired_score = tired_score;
    }else{

      this.tired_score =-1;
      //indicate error
    }
  }

  void print(){
    debugPrint("Tiredscore: " + this.tired_score.toString());
  }


}