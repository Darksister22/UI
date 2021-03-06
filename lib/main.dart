import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:schoolmanagement/editpages/sem_edit.dart';
import 'package:schoolmanagement/mains/course.dart';
import 'package:schoolmanagement/mains/degrees.dart';
import 'package:schoolmanagement/mains/grads.dart';

import 'package:schoolmanagement/mains/homepage.dart';
import 'package:schoolmanagement/mains/instructors.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:schoolmanagement/mains/profilesections.dart';

import 'package:schoolmanagement/mains/settingsmain.dart';
import 'package:schoolmanagement/mains/students.dart';

import 'mains/login.dart';
import 'mains/semester.dart';
import 'mains/users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام اللجنة الامتحانية',
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar", "IQ"),
      ],
      locale: const Locale('ar', 'IQ'),
      theme: ThemeData(primarySwatch: myColor, selectedRowColor: myColor),
      home: const Login(),
      routes: {
        HomePage.id: (_) => const HomePage(),
        ProfileSection.id: (_) => const ProfileSection(),
        Students.id: (_) => const Students(),
        Settings.id: (_) => const Settings(),
        Courses.id: (_) => const Courses(),
        Instructors.id: (_) => const Instructors(),
        Degrees.id: (_) => const Degrees(),
        Users.id: (_) => const Users(),
        Semesters.id: (_) => const Semesters(),
        Grads.id: (_) => const Grads(),
        SemEditMain.id: (_) => const SemEditMain(),
      },
    );
  }
}
