import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:schoolmanagement/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/components/buttoncards.dart';
import 'package:schoolmanagement/mains/semester.dart';

import 'package:schoolmanagement/module/extension.dart';
import 'package:http/http.dart' as http;
import 'package:schoolmanagement/translate.dart';
import '../mains/homepage.dart';
import '../mains/users.dart';

class InstructorSingleDash extends StatefulWidget {
  const InstructorSingleDash({Key? key}) : super(key: key);

  @override
  State<InstructorSingleDash> createState() => _InstructorSingleDashState();
}

class _InstructorSingleDashState extends State<InstructorSingleDash> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _auth = ['الفصل الاول', 'الفصل الثاني'];
  TextEditingController semyearController = TextEditingController();
  TextEditingController semnumController = TextEditingController();
  late String selection = 'الفصل الاول';
  late String sel_level = 'بكالوريوس';
  late String sel_year = 'السنة الاولى';
  final List<String> _Level = [
    'بكالوريوس',
    'ماجستير',
    'دكتوراة',
  ];
  final List<String> _Year = [
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
  // Future _addUsr() async {
  //   var data = {
  //     'email': emailController.text,
  //     'password': passwordController.text,
  //     'role': translateRoleAE(selection),
  //     'name': nameController.text,
  //   };
  //   print(selection);
  //   try {
  //     final response = await CallApi().postData(data, '/api/users/create');
  //     if (response.statusCode == 409) {
  //       context.showSnackBar('البريد الالكتروني مأخوذ سابقاً', isError: true);
  //     } else if (response.statusCode == 403) {
  //       context.showSnackBar('لا تملك الصلاحية', isError: true);
  //     } else {
  //       context.showSnackBar('تم اضافة المستخدم بنجاح');
  //     }
  //     emailController.text = '';
  //     passwordController.text = '';
  //   } catch (e, s) {
  //     print(e);
  //     context.showSnackBar('احد الحقول فارغة او غير صحيحة', isError: true);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0, left: 18.0, right: 18.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الفصول الدراسية",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ButtonCard(
                        bezierCOlor: Colors.blue,
                        value: 'بدأ فصل دراسي جديد',
                        add: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('بدأ فصل دراسي جديد'),
                                content: SizedBox(
                                  height: 212,
                                  child: Column(
                                    children: [
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: semyearController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "لا يمكن ترك الحقل فارغاً";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'السنة الدراسية',
                                                prefixIcon: const Icon(
                                                    Icons.email_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ).margin9,
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 40,
                                                child: ButtonTheme(
                                                  child:
                                                      DropdownButtonFormField(
                                                    isExpanded: true,
                                                    hint:
                                                        const Text('رقم الفصل'),
                                                    value: selection,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selection =
                                                            newValue.toString();
                                                      });
                                                    },
                                                    items: _auth.map((level) {
                                                      return DropdownMenuItem(
                                                        child: Text(level),
                                                        value: level,
                                                      );
                                                    }).toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return " الرجاء اختيار رقم الفصل";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
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
                                      child: const Text('الغاء')),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          //await _addUsr();
                                          // passwordController.text = '';
                                          //   emailController.text = '';
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('اضافة'))
                                ],
                              ),
                            );
                          },
                        ),
                        topColor: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ButtonCard(
                        bezierCOlor: Colors.greenAccent,
                        value: 'بدأ فصل دراسي جديد',
                        add: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('انهاء الفصل الدراسي الحالي'),
                                content: Container(
                                    child: Text(
                                        ' هل انت متأكد؟ لن تتمكن من تعديل الفصل الدراسي هذا بعد انهاءه')),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('الغاء')),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          //await _addUsr();
                                          // passwordController.text = '';
                                          //   emailController.text = '';
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('نعم'))
                                ],
                              ),
                            );
                          },
                        ),
                        topColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
