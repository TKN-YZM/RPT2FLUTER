import 'package:first_app/home.dart';
import 'package:first_app/model/eventlist.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //Hive oluşturma 
  await Hive.initFlutter();
  Hive.registerAdapter(EventDailyAdapter());
  await Hive.openBox<EventDaily>("events");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //En temel tasarım
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.teal,
          appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black))),
      home: const MyHome(), //ana sayfa
    );
  }
}
