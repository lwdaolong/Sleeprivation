
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test1/Activity.dart';
import 'firebase_options.dart';
import 'package:test1/notifi_service.dart';

import 'Caffeine.dart';
import 'Goals.dart';
import 'Personal_Model.dart';
import 'Sleeprivation_Day.dart';
import 'Tiredness.dart';
import 'Sleep.dart';

import 'dart:math';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  //playground
    var caftest = Caffeine(
      caffeine_time: DateTime.now(),
    );


  //Log In User Example
  Personal_Model? new_user = await Personal_Model.loginUser("Sean");
  if(new_user != null){
    //new_user.debuglog();
  }


  /*
  //Create User Example

  Goals exampleGoals = new Goals(8*60, TimeOfDay(hour:8,minute: 0));
  Personal_Model? new_user = await Personal_Model.createNewUser("Sean", exampleGoals);
  if(new_user != null){
    new_user.debuglog();
  }
  */










  Sleep testsleep = Sleep.parse("2023-03-09 14:11:06.039", "2023-03-13 14:11:06.039", "60");

  Sleeprivation_Day testday = new Sleeprivation_Day(DateTime.parse("2023-03-09 22:16:40.805"), caftest, testsleep, Tiredness(7), Activity(9250));

  new_user?.today = testday;

  //new_user.debuglog();


  await new_user?.pushTodayIntoLogsDB();
  await new_user?.retrieveAllLogsDB();
  //print('log length');
  //new_user?.debuglog();


  /*
  final week_log = [
  Sleeprivation_Day(DateTime.now(), caftest, ideal, new Tiredness(6), new Activity(1000)),
    Sleeprivation_Day(DateTime.now(), caftest, ideal, new Tiredness(6), new Activity(1000)),
    Sleeprivation_Day(DateTime.now(), caftest, Sleep.parse("2023-03-10 22:11:06.039", "2023-03-11 08:11:06.039", "100"), new Tiredness(5), new Activity(1000)),
    Sleeprivation_Day(DateTime.now(), caftest, Sleep.parse("2023-03-11 23:11:06.039", "2023-03-12 08:11:06.039", "100"), new Tiredness(6), new Activity(1000)),
    Sleeprivation_Day(DateTime.now(), caftest, Sleep.parse("2023-03-12 00:11:06.039", "2023-03-13 08:11:06.039", "100"), new Tiredness(8), new Activity(1000)),
    Sleeprivation_Day(DateTime.now(), caftest, Sleep.parse("2023-03-13 01:11:06.039", "2023-03-14 09:11:06.039", "100"), new Tiredness(8), new Activity(1000)),
    Sleeprivation_Day(DateTime.now(), caftest, Sleep.parse("2023-03-14 23:11:06.039", "2023-03-15 09:11:06.039", "100"), new Tiredness(10), new Activity(1000)),
    Sleeprivation_Day(DateTime.now(), caftest, Sleep.parse("2023-03-15 01:11:06.039", "2023-03-16 08:11:06.039", "100"), new Tiredness(9), new Activity(1000)),
    Sleeprivation_Day(DateTime.now(), caftest, Sleep.parse("2023-03-16 22:11:06.039", "2023-03-17 08:11:06.039", "100"), new Tiredness(5), new Activity(1000)),
  ];
   */

  //!!!!!!!!!!!!!!

  Goals testgoal = new Goals(8*60, TimeOfDay(hour: 7,minute: 00));


  // Define the list of sleep tuples
  final sleep_log = [
    Sleep.parse("2023-03-10 22:11:06.039", "2023-03-11 08:11:06.039", "0"),
    Sleep.parse("2023-03-11 23:11:06.039", "2023-03-12 08:11:06.039", "0"),
    Sleep.parse("2023-03-12 00:11:06.039", "2023-03-13 08:11:06.039", "0"),
    Sleep.parse("2023-03-13 01:11:06.039", "2023-03-14 09:11:06.039", "0"),
    Sleep.parse("2023-03-14 23:11:06.039", "2023-03-15 09:11:06.039", "0"),
    Sleep.parse("2023-03-15 01:11:06.039", "2023-03-16 08:11:06.039", "0"),
    Sleep.parse("2023-03-16 22:11:06.039", "2023-03-17 08:11:06.039", "0"),
  ];


  //SleepRecommendationTuple ihopethisworks = getSleepRecommendationTuple(sleep_log, testgoal, 1);
  //print(ihopethisworks.loss);
  //print(ihopethisworks.rec_bedtime.toString());

  // Find the 3 most ideal bedtimes closest to the user's sleep duration goal
  //final idealTuples = findIdealTuples(sleepTuples, sleepDurationGoal, 3);

  // Calculate the average bedtime of the 3 most ideal tuples
  //final averageBedtime = idealTuples.map((t) => t.bedtime).reduce((a, b) => a + b) / idealTuples.length;

  // Print the average bedtime
  //print('Average bedtime of the 3 most ideal tuples: $averageBedtime:00');



  //playground


  runApp(const MyApp());
}












//AAAHHAHAHHAHAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH PLAYGROUND^^ TODO MOVE EVERYTHING ABOVE INTO OTHER MODULES

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //TEST
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleeprivation',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:  ()=> FirebaseFirestore.instance
              .collection('testing')
              .add({'timestamp': Timestamp.fromDate(DateTime.now())}),
          child:Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('testing').snapshots(),
          builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
              ){
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index){
                final docData = snapshot.data?.docs[index];
                final dateTime = (docData!['timestamp'] as Timestamp).toDate();
                return ListTile(
                  title: Text(dateTime.toString()),
                );
              },

            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPageIndex = 0;

  void _onNavigationBarSelected(int index) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Looks like you haven\'t entered your sleep data for today',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            TextButton(
              child: Text("Enter Data"),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red))),
              ),
              onPressed: () {
                NotificationService()
                    .showNotification(title: 'Bed Time!', body: 'Get 8 full hours!');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda_rounded),
            label: 'Sleep Log',
          ),
        ],
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.orange,
        onTap: _onNavigationBarSelected,
      ),
    );
  }
}

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }
  // @override
  // Widget build(BuildContext context) {
  //   // This method is rerun every time setState is called, for instance as done
  //   // by the _incrementCounter method above.
  //   //
  //   // The Flutter framework has been optimized to make rerunning build methods
  //   // fast, so that you can just rebuild anything that needs updating rather
  //   // than having to individually change instances of widgets.
  //   return Scaffold(
  //     appBar: AppBar(
  //       // Here we take the value from the MyHomePage object that was created by
  //       // the App.build method, and use it to set our appbar title.
  //       title: Text(widget.title),
  //     ),
  //     body: Center(
  //       // Center is a layout widget. It takes a single child and positions it
  //       // in the middle of the parent.
  //       child: Column(
  //         // Column is also a layout widget. It takes a list of children and
  //         // arranges them vertically. By default, it sizes itself to fit its
  //         // children horizontally, and tries to be as tall as its parent.
  //         //
  //         // Invoke "debug painting" (press "p" in the console, choose the
  //         // "Toggle Debug Paint" action from the Flutter Inspector in Android
  //         // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
  //         // to see the wireframe for each widget.
  //         //
  //         // Column has various properties to control how it sizes itself and
  //         // how it positions its children. Here we use mainAxisAlignment to
  //         // center the children vertically; the main axis here is the vertical
  //         // axis because Columns are vertical (the cross axis would be
  //         // horizontal).
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           const Text(
  //             'You have clicked the button this many times:',
  //           ),
  //           Text(
  //             '$_counter',
  //             style: Theme.of(context).textTheme.headline4,
  //           ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _incrementCounter,
  //       tooltip: 'Increment',
  //       child: const Icon(Icons.add),
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }


/*

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //TEST
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleeprivation',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Sleeprivation'),
    );
  }
}

 */

/*
FIREBASE CODE
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //TEST
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleeprivation',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:  ()=> FirebaseFirestore.instance
            .collection('testing')
            .add({'timestamp': Timestamp.fromDate(DateTime.now())}),
          child:Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('testing').snapshots(),
          builder: (
            BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
          ){
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index){
                  final docData = snapshot.data?.docs[index];
                  final dateTime = (docData!['timestamp'] as Timestamp).toDate();
                  return ListTile(
                    title: Text(dateTime.toString()),
                  );
                },

            );
          },
        ),
      ),
    );
  }
}
 */

/*
NOTIFICATION CODE
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //TEST
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleeprivation',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Sleeprivation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPageIndex = 0;

  void _onNavigationBarSelected(int index) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Looks like you haven\'t entered your sleep data for today',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            TextButton(
              child: Text("Enter Data"),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red))),
              ),
              onPressed: () {
                NotificationService()
                    .showNotification(title: 'Bed Time!', body: 'Get 8 full hours!');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda_rounded),
            label: 'Sleep Log',
          ),
        ],
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.orange,
        onTap: _onNavigationBarSelected,
      ),
    );
  }
}

 */


/*
TEST BOILERPLATE CODE THAT WORKS

//playground

  //caffeine FireStore Test
  var caftest = Caffeine(
    caffeine_time: DateTime.now(),
  );

  var docRef = FirebaseFirestore.instance
      .collection("testing_new")
  .withConverter(
      fromFirestore: Caffeine.fromFirestore,
      toFirestore: (Caffeine caftest, options) => caftest.toFirestore(),
  )
  .doc("idk");
  await docRef.set(caftest);


  //Personal Model Tests
  Personal_Model.getUserFromDB('Logan');

  //!!!!!!!!!!!!!!


  TimeOfDay wake = TimeOfDay(hour: 8,minute: 30);
  print("You should sleep at ");
  print(calculateAppropriateBedTime(wake, 8*60));
  print("if you wake up at ");
  print(wake);
  print("and you want to sleep for 8 hours");

  //playground

 */

/*
//goals FireStore Test
  var tempgoal = new Goals(8*60, TimeOfDay(hour: 8,minute: 30));
  tempgoal.print();


  //set reference
  final goalref = FirebaseFirestore.instance.collection("testing_new")
  .doc("newGoal")
  .withConverter(
      fromFirestore: Goals.fromFirestore,
      toFirestore: (Goals tempgoal, _) => tempgoal.toFirestore(),
  );

  //update goal DB
  await goalref.set(tempgoal);

  print("Goal constructed from Firebase");
  var newgoaldata = await goalref.get();
  Goals newgoal = newgoaldata.data() as Goals;
  newgoal.print();

  //############################### usage

  Goals logangoals = new Goals(5*60, TimeOfDay(hour:12,minute: 30));
  Personal_Model new_user = new Personal_Model("Logan", logangoals);

  new_user.goals.print();

  Goals logannewgoals = new Goals(8*60, TimeOfDay(hour:8,minute: 30));
  await new_user.setGoalDebug("Logan", logannewgoals);
  new_user.goals.print();


  await new_user.updateGoalsfromDBDebug("Logan");

  new_user.goals.print();
 */