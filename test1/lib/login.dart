import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'globals.dart' as globals;
import 'Personal_Model.dart';

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  LoginForm({super.key, required this.title});
  final String title;

  @override
  MyLoginForm createState() {
    return MyLoginForm();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyLoginForm extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String? _username;

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
    } else {
      form.save();
      Personal_Model? new_user = await Personal_Model.loginUser("$_username");
      if (new_user == null) {
        showSimpleNotification(Text("User does not exist"));
      } else {
        globals.loggedInUser = new_user;
        globals.allLogs = await new_user!.getAllLogsDB();

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', ModalRoute.withName('/home'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter Login Info",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                    onSaved: (String? value) {
                      _username = value;
                    },
                  ),
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        side: BorderSide(width: 1, color: Colors.black)),
                    // onPressed: () {
                    //   if (_formKey.currentState!.validate()) {
                    //     Navigator.of(context).pushNamedAndRemoveUntil(
                    //         '/home', ModalRoute.withName('/home'));
                    //   }
                    // },
                    onPressed: _handleSubmitted,
                    child: Text("Login",
                        style: Theme.of(context).textTheme.titleMedium))
              ],
            ),
          ))
        ])));
  }
}
