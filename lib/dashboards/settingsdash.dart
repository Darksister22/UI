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
import '../editpages/sem_edit.dart';
import '../mains/homepage.dart';
import '../mains/users.dart';

class SettingsDash extends StatefulWidget {
  const SettingsDash({Key? key}) : super(key: key);

  @override
  State<SettingsDash> createState() => _SettingsDashState();
}

class _SettingsDashState extends State<SettingsDash> {
  final List<String> _auth = ['عضو - قراءة و تعديل', 'رئيس - جميع الصلاحيات'];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController amtController = TextEditingController();
  late String selection = 'عضو - قراءة و تعديل';
  final _formKey = GlobalKey<FormState>();

  Future _addUsr() async {
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
      'role': translateRoleAE(selection),
      'name': nameController.text,
    };

    try {
      final response = await CallApi().postData(data, '/api/users/create');
      if (response.statusCode == 409) {
        context.showSnackBar('البريد الالكتروني مأخوذ سابقاً', isError: true);
      } else if (response.statusCode == 403) {
        context.showSnackBar('لا تملك الصلاحية', isError: true);
      } else {
        context.showSnackBar('تم اضافة المستخدم بنجاح');
      }
      emailController.text = '';
      passwordController.text = '';
    } catch (e, s) {
      print(e);
      context.showSnackBar('احد الحقول فارغة او غير صحيحة', isError: true);
    }
  }

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
                    "تعديل معلومات النظام",
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
                        value: 'اضافة مستخدم',
                        add: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('اضافة مستخدم جديد'),
                                content: Column(
                                  children: [
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: emailController,
                                            textDirection: TextDirection.ltr,
                                            validator: (value) => EmailValidator
                                                    .validate(value!)
                                                ? null
                                                : "البريد الالكتروني غير صحيح",
                                            decoration: InputDecoration(
                                              labelText: ' البريد الالكتروني',
                                              prefixIcon: const Icon(
                                                  Icons.email_outlined),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ).margin9,
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            controller: nameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "لا يمكن ترك الحقل فارغاً";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: ' اسم المستخدم',
                                              prefixIcon: const Icon(
                                                  Icons.email_outlined),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ).margin9,
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            controller: passwordController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "لا يمكن ترك الحقل فارغاً";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'كلمة السر',
                                              prefixIcon:
                                                  const Icon(Icons.password),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ).margin9,
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 40,
                                              child: ButtonTheme(
                                                child: DropdownButtonFormField(
                                                  isExpanded: true,
                                                  hint: const Text(
                                                      'صلاحية المستخدم'),
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
                                                      return "الرجاء اختيار صلاحية المستخدم";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                          await _addUsr();
                                          nameController.text = '';
                                          passwordController.text = '';
                                          emailController.text = '';
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
                        value: 'تعديل معلومات المستخدمين',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Users(),
                              ),
                            );
                          },
                        ),
                        topColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ButtonCard(
                        bezierCOlor: Colors.orange,
                        value: 'تعديل الفصل الدراسي',
                        add: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SemEditMain(),
                              ),
                            );
                          },
                        ),
                        topColor: Colors.orange,
                      ),
                      SizedBox(
                        width: _width / 64,
                      ),
                      ButtonCard(
                        bezierCOlor: Colors.cyanAccent,
                        value: 'اضافة درجات مساعدة',
                        add: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('اضافة درجات مساعدة'),
                                content: Container(
                                  height: 212,
                                  child: Column(
                                    children: [
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: sourceController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "لا يمكن ترك الحقل فارغاً";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'مصدر الدرجة',
                                                prefixIcon: const Icon(
                                                    Icons.email_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ).margin9,
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: nameController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "لا يمكن ترك الحقل فارغاً";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'مقدار الدرجة',
                                                prefixIcon: const Icon(
                                                    Icons.email_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ).margin9,
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
                                          await _addUsr();
                                          nameController.text = '';
                                          passwordController.text = '';
                                          emailController.text = '';
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('اضافة'))
                                ],
                              ),
                            );
                          },
                        ),
                        topColor: Colors.cyanAccent,
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
