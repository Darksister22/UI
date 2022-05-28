import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/homepage.dart';
import 'package:schoolmanagement/stylefiles/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../module/extension.dart';
import '../components/main_widgets.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  Future _login() async {
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      final response = await http
          .post(Uri.parse('http://127.0.0.1:8000/api/users/login'), body: data);
      if (response.statusCode == 401) {
        context.showSnackBar(
            'البريد الالكتروني او الرقم السري غير صحيح, يرجى اعادة المحاولة',
            isError: true);
      } else {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        await localStorage.setString(
            'token', json.decode(response.body)['access_token']);
        await localStorage.setString(
            'role', json.decode(response.body)['role']);

        context.showSnackBar('تم تسجيل الدخول بنجاح');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } catch (e) {
      print(e);
      context.showSnackBar('حدث خطأ ما, يرجى اعادة المحاولة', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: context.width * 0.3 < 250 ? 250 : context.width * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'اللجنة الامتحانية - جامعة النهرين'
                  .toLabel(bold: true, color: Colors.grey[600], fontSize: 20),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      textDirection: TextDirection.ltr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء ادخال اسم مستخدم';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).padding9,
                    TextFormField(
                      controller: passwordController,
                      textDirection: TextDirection.ltr,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء ادخال كلمة سر';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'كلمة السر',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).padding9,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'تسجيل الدخول',
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
                                  if (states.contains(MaterialState.pressed))
                                    return blue;
                                  return blue;
                                  // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _login();
                              }
                            },
                          ).margin9,
                        ),
                        Expanded(
                          child: TextButton(
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'الدخول كضيف',
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
                                  if (states.contains(MaterialState.pressed))
                                    return blue;
                                  return blue;
                                  // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                          ).margin9,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).padding9.card.center,
      ),
    );
  }
}
