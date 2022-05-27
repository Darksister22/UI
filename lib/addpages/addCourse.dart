import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:schoolmanagement/mains/course.dart';

import 'package:schoolmanagement/components/sidemenus.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/mains/homepage.dart';

import '../mains/login.dart';

class addCourse extends StatefulWidget {
  const addCourse({Key? key}) : super(key: key);

  @override
  _addCourseState createState() => _addCourseState();
}

class _addCourseState extends State<addCourse> {
  final _courseEN = TextEditingController();
  final _courseAR = TextEditingController();
  final _code = TextEditingController();
  final _unit = TextEditingController();
  final _success = TextEditingController(text: '50');
  final _semester = TextEditingController(text: '2021-2022');
  List<String> _Level = [
    'بكالوريوس',
    'ماجستير',
    'دكتوراة',
  ];
  List<String> _Year = [
    'السنة الاولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'السنة الخامسة',
    'السنة السادسة',
    'السنة الثامنة',
    'السنة التاسعة',
    'السنة العاشرة',
  ];
  List<String> _Instructor = ['1', '2', '3'];
  String? sel_level;
  String? sel_year;
  String? sel_inst;
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
                child: CustomText(
              text: 'اضافة كورس جديد',
              color: lightgrey,
              size: 20,
              fontWeight: FontWeight.bold,
            )),
            Expanded(
              child: Container(),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: dark.withOpacity(.7),
              onPressed: () {},
            ),
            Container(
              width: 1,
              height: 22,
              color: lightgrey,
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              color: dark.withOpacity(.7),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 24,
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: dark,
        ),
        backgroundColor: light,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _courseEN,
                        decoration: InputDecoration(
                          labelText: 'اسم الكورس English',
                          prefixIcon: Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _courseAR,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال اسم الكورس';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'اسم الكورس*',
                          prefixIcon: Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال كود الكورس';
                          }
                          return null;
                        },
                        controller: _code,
                        decoration: InputDecoration(
                          labelText: 'كود الكورس*',
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال وحدة الكورس';
                          }
                          return null;
                        },
                        controller: _unit,
                        decoration: InputDecoration(
                          labelText: '*وحدة الكورس',
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _success,
                        decoration: InputDecoration(
                          labelText: 'درجة النجاح*',
                          prefixIcon: Icon(Icons.check),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      TextFormField(
                        controller: _semester,
                        decoration: InputDecoration(
                          labelText: 'الفصل الدراسي*',
                          prefixIcon: Icon(Icons.date_range),
                          enabled: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: Text('*اختيار السنة الدراسية'),
                              value: sel_year,
                              onChanged: (newValue) {
                                setState(() {
                                  sel_year = newValue.toString();
                                });
                              },
                              items: _Year.map((year) {
                                return DropdownMenuItem(
                                  child: new Text(year),
                                  value: year,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: Text('*اختيار المرحلة الدراسية'),
                              value: sel_level,
                              onChanged: (newValue) {
                                setState(() {
                                  sel_level = newValue.toString();
                                });
                              },
                              items: _Level.map((level) {
                                return DropdownMenuItem(
                                  child: new Text(level),
                                  value: level,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: Text('*اختيار التدريسي'),
                              value: sel_inst,
                              onChanged: (newValue) {
                                setState(() {
                                  sel_inst = newValue.toString();
                                });
                              },
                              items: _Instructor.map((inst) {
                                return DropdownMenuItem(
                                  child: new Text(inst),
                                  value: inst,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width) / 3,
                        child: TextButton(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'الغاء',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return blue;
                                // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Courses(),
                              ),
                            );
                          },
                        ).margin9,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width) / 3,
                        child: TextButton(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'اضافة',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return blue;
                                // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Courses(),
                              ),
                            );
                          },
                        ).margin9,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
