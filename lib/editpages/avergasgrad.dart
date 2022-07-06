import 'package:flutter/material.dart';
import 'package:schoolmanagement/models/grads.dart';


class AveragesGrad extends StatefulWidget {
  final Grad current;
  const AveragesGrad({Key? key, required this.current}) : super(key: key);

  @override
  State<AveragesGrad> createState() => _AveragesGradState();
}

class _AveragesGradState extends State<AveragesGrad> {
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
              ListTile(
                title: const Text("المعدل التراكمي"),
                leading: Text(widget.current.avgfinal.toString()),
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
