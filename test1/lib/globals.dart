library globals;

import 'Personal_Model.dart';
import 'Sleeprivation_Day.dart';

bool dataEntered = false;
String temp = "11:00 PM";
String sleepScore = "89/100";
Personal_Model? loggedInUser;
List<Sleeprivation_Day>? allLogs;
List<Recommendation>? recCards;

DateTime? lastCaffeine;
int? currentSteps;

bool startedStepCountRefresh = false;
