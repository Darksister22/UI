import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoolmanagement/models/student.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schoolmanagement/components/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addpages/attend.dart';
import '../api.dart';
import '../mains/students.dart';
import '../models/course.dart';

class stuEditAlert extends StatefulWidget {
  final Student student;
  final Course current;
  stuEditAlert({Key? key, required this.current, required this.student})
      : super(key: key);

  @override
  State<stuEditAlert> createState() => _stuEditAlertState();
}

class _stuEditAlertState extends State<stuEditAlert> {
  @override
  void initState() {
    super.initState();
  }

  // static String namear = current.level;
  var snack = '';

  var error = false;

  // Future _delStu() async {
  //   String id = widget.current.id.toString();
  //   var data = {
  //     'id': id,
  //     'name_ar': nameAr.text,
  //     'name_en': nameEn.text,
  //     "level": translateLevelAE(sel_level),
  //     "year": translateYearAE(sel_year)
  //   };

  //   try {
  //     final response =
  //         await CallApi().postData(data, "/api/students/destroy/$id");

  //     snack = 'تم حذف الطالب بنجاح';
  //   } catch (e) {
  //     snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
  //     error = true;
  //   }
  // }

  // Future _editStu() async {
  //   String id = widget.current.id.toString();
  //   var data = {
  //     "id": id,
  //     'name_ar': nameAr.text,
  //     'name_en': nameEn.text,
  //     "level": translateLevelAE(sel_level),
  //     "year": translateYearAE(sel_year),
  //     "note": note.text
  //   };

  //   try {
  //     final response = await CallApi().postData(data, "/api/students/update");

  //     snack = 'تم تحديث معلومات الطالب بنجاح';
  //   } catch (e) {
  //     snack = 'حدث خطاُ ما يرجى اعادة المحاولة';
  //     error = true;
  //   }
  // }

  final _formKey = GlobalKey<FormState>();
  final fourty = TextEditingController();
  final sixty1 = TextEditingController();
  final sixty2 = TextEditingController();
  final sixty3 = TextEditingController();
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('درجات الطالب'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: fourty,
                      validator: (value) {
                        if (int.parse(value!) > 40) {
                          return 'لا يمكن ادخال درجة اكبر من 40';
                        }
                        return null;
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'درجة السعي',
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).margin9,
                    TextFormField(
                      controller: sixty1,
                      validator: (value) {
                        if (int.parse(value!) > 60) {
                          return 'لا يمكن ادخال درجة اكبر من 60';
                        }
                        return null;
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'درجة الامتحان النهائي الاول',
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).margin9,
                    TextFormField(
                      controller: sixty2,
                      validator: (value) {
                        if (int.parse(value!) > 60) {
                          return 'لا يمكن ادخال درجة اكبر من 60';
                        }
                        return null;
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'درجة الامتحان النهائي الثاني',
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).margin9,
                    TextFormField(
                      controller: sixty3,
                      validator: (value) {
                        if (int.parse(value!) > 60) {
                          return 'لا يمكن ادخال درجة اكبر من 60';
                        }
                        return null;
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'درجة الامتحان النهائي الثالث',
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).margin9,
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('الخروج')),
          ElevatedButton(
              onPressed: () async {}, child: const Text('حفظ التغييرات')),
        ],
      );
    });
  }
}
