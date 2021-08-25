import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/screens/splash_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff6B705C), //appbar backgrounds
        accentColor: Color(0xff6B705C), //buttons
        backgroundColor: Color(0xffFFE8D6),
        // canvasColor: Color(0xff6B705C),
        canvasColor: Colors.grey[300],
        scaffoldBackgroundColor: Colors.grey[300],
        // accentColor: Color(0xffFFE8D6),

        // brightness: Brightness.dark,

        textTheme: TextTheme(
          headline1: normalText,
          headline6: normalText,
          bodyText1: normalText,
          bodyText2: normalText,
          subtitle1: tileText,
          subtitle2: tileText,
        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(

              // headline1: boldText,
              // headline6: boldText,
              // bodyText1: boldText,
              // bodyText2: boldText,
              // subtitle1: boldText,
              ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await FirebaseFirestore.instance
        .collection("cpont")
        .doc("test")
        .set({"cpunt": _counter});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
