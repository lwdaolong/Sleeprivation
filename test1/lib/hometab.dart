import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, this.dataEntered = false});
  final bool dataEntered;
  @override
  State<HomeTab> createState() => _MyHomeTab();
}

class _MyHomeTab extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.dataEntered) {
      return Container(
          child: Center(child: Container(child: Text('home tab'))));
    } else {
      return EnterDataTab();
    }
  }
}

class EnterDataTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Looks like you haven\'t entered your sleep data for today',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  side: BorderSide(width: 1),
                ),
                child: Text('Enter data',
                    style: Theme.of(context).textTheme.bodyLarge),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EnterDataModal(),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class EnterDataModal extends StatefulWidget {
  const EnterDataModal({super.key});
  @override
  State<EnterDataModal> createState() => _EnterDataModal();
}

class _EnterDataModal extends State<EnterDataModal> {
  @override
  Widget build(BuildContext context) {
    // return Container(child: Center(child: Container(child: Text('home tab'))));
    return Scaffold(
        appBar: AppBar(
          title: Text('Enter Data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Text('How would you rate the quality of your sleep last night?',
                  style: Theme.of(context).textTheme.bodyLarge),
              // SizedBox(height: 10),
              SleepRatingSlider(),
              Column(
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        side: BorderSide(width: 1),
                      ),
                      child: Text('Submit data',
                          style: Theme.of(context).textTheme.bodyLarge),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ],
          ),
        ));
  }
}

class SleepRatingSlider extends StatefulWidget {
  const SleepRatingSlider({super.key});

  @override
  State<SleepRatingSlider> createState() => _SleepRatingSlider();
}

class _SleepRatingSlider extends State<SleepRatingSlider> {
  double _currentSliderValue = 5;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      max: 10,
      divisions: 10,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}