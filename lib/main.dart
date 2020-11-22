
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:here_sdk/core.dart';
import 'about_us.dart';
import 'register.dart';
import 'login.dart';

void main() {
  SdkContext.init(IsolateOrigin.main);
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: ClipOval(
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => About_Us()
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius:190,
                      backgroundImage: AssetImage('images/mapsafe_logo.png'),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 0.0),
                  child: Container(
                    width: 100,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()
                          ),
                        );
                      },
                      textColor: Colors.white70,
                      child: Container(
                        child:
                        const Text('Login', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 0.0),
                  child: Container(
                    width: 100.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()
                          ),
                        );
                      },
                      color: Colors.black,
                      textColor: Colors.white70,
                      child: Container(
                        decoration: const BoxDecoration(

                        ),
                        child:
                        const Text('Sign up', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}















