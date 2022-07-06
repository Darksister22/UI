import 'package:flutter/material.dart';
import 'package:schoolmanagement/models/student.dart';

import '../api.dart';

class Averages extends StatefulWidget {
  final Student current;
  const Averages({Key? key, required this.current}) : super(key: key);

  @override
  State<Averages> createState() => _AveragesState();
}

class _AveragesState extends State<Averages> {
  Future<String> _avg() async {
    String id = widget.current.id.toString();

    try {
      final res = await CallApi().getData("/api/students/getCurAvg?id=$id");
      return res.body;
    } catch (e) {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('عرض معدلات الطالب'),
        content: SizedBox(
          height: 300,
          width: 300,
          child: ListView(
            children: [
              ListTile(
                title: const Text("معدل السنة الاولى"),
                leading: Text(check(widget.current.avg1.toString())),
              ),
              ListTile(
                title: const Text("معدل السنة الثانية"),
                leading: Text(check(widget.current.avg2.toString())),
              ),
              ListTile(
                title: const Text("معدل السنة الثالثة"),
                leading: Text(check(widget.current.avg3.toString())),
              ),
              ListTile(
                title: const Text("معدل السنة الرابعة"),
                leading: Text(check(widget.current.avg4.toString())),
              ),
              ListTile(
                title: const Text("معدل السنة الخامسة"),
                leading: Text(check(widget.current.avg5.toString())),
              ),
              FutureBuilder<String>(
                  future: _avg(),
                  builder: (context, snapshot) {
                    return ListTile(
                      title: const Text("معدل الكورس الحالي"),
                      leading: Text(snapshot.data.toString()),
                    );
                  }),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('الخروج')),
        ],
      );
    });
  }

  String check(String col) {
    if (col == "null") {
      return "لا يوجد";
    } else {
      return col;
    }
  }
}
