// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/course.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/stylefiles/customtext.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../mains/login.dart';
import '../mains/settingsmain.dart';
import '../models/instructor.dart';
import '../translate.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({Key? key}) : super(key: key);

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _courseEN = TextEditingController();
  final _courseAR = TextEditingController();
  final _code = TextEditingController();
  final _unit = TextEditingController();
  final _success = TextEditingController(text: '50');
  final _intructor = TextEditingController();
  final List<String> _level = [
    'بكالوريوس',
    'ماجستير',
    'دكتوراة',
  ];
  bool isSwitched = true;
  final List<String> _year = [
    'السنة الاولى',
    'السنة الثانية',
    'السنة الثالثة',
    'السنة الرابعة',
    'السنة الخامسة',
  ];

  var snack = '';
  var error = false;
  String? sellevel;
  String? selins;
  String? selyear;
  late Future<List<Instructor>> futureAlbum;
  List<Instructor> _data = [];
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Visibility(
                child: CustomText(
              text: 'اضافة مادة جديدة',
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
                onPressed: () async {
                  SharedPreferences localStorage =
                      await SharedPreferences.getInstance();

                  if (localStorage.getString("token") == null ||
                      localStorage.getString("role") == "admin") {
                    context.showSnackBar('لا تملك صلاحية الوصول',
                        isError: true);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  }
                }),
            Container(
              width: 1,
              height: 22,
              color: lightgrey,
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              color: dark.withOpacity(.7),
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
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
      body: SizedBox(
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
                        textDirection: TextDirection.ltr,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال اسم المادة';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'اسم المادة English',
                          prefixIcon: const Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: FutureBuilder<List<Instructor>>(
                              future: futureAlbum,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  _data = snapshot.data ?? [];
                                  List<String> list = [];
                                  for (var i = 0; i < _data.length; i++) {
                                    list.add(_data[i].nameAr);
                                  }
                                  return StatefulBuilder(
                                    builder: (BuildContext context, setState) {
                                      return DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        validator: (value) {
                                          if (value == null) {
                                            return " الرجاء  اختيار التدريسي ";
                                          }
                                          return null;
                                        },
                                        hint: const Text('اختيار التدريسي'),
                                        value: selins,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selins = newValue.toString();
                                          });
                                        },
                                        items: list.map((ins) {
                                          return DropdownMenuItem(
                                            child: Text(ins),
                                            value: ins,
                                          );
                                        }).toList(),
                                      );
                                    },
                                  );
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    CircularProgressIndicator(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _courseAR,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال اسم المادة';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'اسم المادة',
                          prefixIcon: const Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value!;
                                });
                              }),
                          Text(
                            'المادة تشمل عند احتساب المعدل',
                            style: header,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال كود المادة';
                          }
                          return null;
                        },
                        controller: _code,
                        decoration: InputDecoration(
                          labelText: 'كود المادة',
                          prefixIcon: const Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال وحدة المادة';
                          }
                          return null;
                        },
                        controller: _unit,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'وحدة المادة',
                          prefixIcon: const Icon(Icons.numbers),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _success,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء ادخال درجة النجاح للمادة';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'درجة النجاح',
                          prefixIcon: const Icon(Icons.check),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ).margin9,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text('اختيار المرحلة الدراسية'),
                              value: sellevel,
                              onChanged: (newValue) {
                                setState(() {
                                  sellevel = newValue.toString();
                                });
                              },
                              items: _level.map((level) {
                                return DropdownMenuItem(
                                  child: Text(level),
                                  value: level,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ButtonTheme(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text('اختيار السنة الدراسية'),
                              value: selyear,
                              onChanged: (newValue) {
                                setState(() {
                                  selyear = newValue.toString();
                                });
                              },
                              items: _year.map((year) {
                                return DropdownMenuItem(
                                  child: Text(year),
                                  value: year,
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
                      child: SizedBox(
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
                      child: SizedBox(
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _addCrs();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Courses(),
                                ),
                              );

                              context.showSnackBar(snack, isError: error);
                            }
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

  Future<List<Instructor>> fetchAlbum() async {
    final response = await CallApi().getData('/api/instructors');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as List;

      return result.map((e) => Instructor.fromJson(e)).toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load');
    }
  }

  Future _addCrs() async {
    var data = {
      'name_ar': _courseAR.text,
      'name_en': _courseEN.text,
      "level": translateLevelAE(sellevel!),
      "year": translateYearAE(selyear!),
      "code": _code.text,
      "unit": _unit.text,
      "success": _success.text,
      "isCounts": isSwitched,
      "ins_name": selins,
    };

    try {
      final response = await CallApi().postData(data, '/api/courses/create');

      if (response.statusCode == 409) {
        snack = 'لا يوجد تدريسي بهذا الاسم';
        error = true;
      } else {
        snack = 'تم اضافة الكورس بنجاح';
      }
      _courseAR.text = '';
      _courseEN.text = '';
      _code.text = "";
      _unit.text = "";
      _success.text = "50";
      _intructor.text = "";
    } catch (e) {
      snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
      error = true;
    }
  }
}
