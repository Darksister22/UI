import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/deg_year.dart';
import 'package:schoolmanagement/models/degree.dart';

import '../api.dart';
import '../models/help.dart';
import '../models/helpstu.dart';

class AddHelp extends StatefulWidget {
  final Degree current;

  const AddHelp({Key? key, required this.current}) : super(key: key);

  @override
  State<AddHelp> createState() => _AddHelpState();
}

class _AddHelpState extends State<AddHelp> {
  String? selAmt;
  List<Help> _data = [];
  @override
  void initState() {
    super.initState();
    future = _get();
  }

  Future<List<Help>> fetch() async {
    final response = await CallApi().getData('/api/degrees/showhelp');
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as List;
      return result.map((e) => Help.fromJson(e)).toList();
    } else {
      throw ('');
    }
  }

  late Future<List<HelpStu>> future;
  Future<List<HelpStu>> _get() async {
    String id = widget.current.id.toString();
    try {
      final response =
          await CallApi().getData('/api/degrees/helpstu?deg_id=$id');
      final result = jsonDecode(response.body) as List;
      return result.map((e) => HelpStu.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future _addHelp() async {
    var data = {'source': selAmt, "deg_id": widget.current.id};

    try {
      await CallApi().postData(data, '/api/degrees/addhelp');
    } catch (e) {
      rethrow;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        height: 1000,
        child: AlertDialog(
          title: const Text('درجات المساعدة للطالب'),
          content: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ButtonTheme(
                          child: FutureBuilder<List<Help>?>(
                            future: fetch(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                _data = snapshot.data ?? [];
                                List<String> list = [];
                                for (var i = 0; i < _data.length; i++) {
                                  list.add(_data[i].source);
                                }
                                return StatefulBuilder(
                                  builder: (BuildContext context, setState) {
                                    return Column(
                                      children: [
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
                                                hint:
                                                    const Text('اختيار المصدر'),
                                                value: selAmt,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selAmt =
                                                        newValue.toString();
                                                  });
                                                },
                                                items: list.map((ins) {
                                                  return DropdownMenuItem(
                                                    child: Text(ins),
                                                    value: ins,
                                                  );
                                                }).toList(),
                                                validator: (value) {
                                                  if (value == null) {
                                                    context.showSnackBar(
                                                        "الرجاء اختيار مصدر الدرجة",
                                                        isError: true);
                                                    Navigator.pop(context);
                                                    return "الرجاء اختيار مصدر الدرجة ";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FutureBuilder<List<HelpStu>>(
                                          future: future,
                                          builder: (context, snapshot) {
                                            List<HelpStu> _data =
                                                snapshot.data ?? [];

                                            if (snapshot.hasData) {
                                              return SizedBox(
                                                height: 100,
                                                child: ListView.builder(
                                                  itemCount: _data.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return ListTile(
                                                      leading: Text(_data[index]
                                                          .amt
                                                          .toString()),
                                                      trailing: Text(
                                                          _data[index].source),
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                            return const CircularProgressIndicator();
                                          },
                                        )
                                      ],
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
                    await _addHelp();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DegYear(),
                      ),
                    );
                  }
                },
                child: const Text('اضافة'))
          ],
        ),
      );
    });
  }
}
