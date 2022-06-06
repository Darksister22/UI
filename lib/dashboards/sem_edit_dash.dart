import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolmanagement/api.dart';
import 'package:schoolmanagement/components/buttoncards.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/module/extension.dart';
import 'package:schoolmanagement/translate.dart';

class SemesterEditDash extends StatefulWidget {
  const SemesterEditDash({Key? key}) : super(key: key);

  @override
  State<SemesterEditDash> createState() => _SemesterEditDashState();
}

class _SemesterEditDashState extends State<SemesterEditDash> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _number = ['الكورس الاول', 'الكورس الثاني'];
  String? selection;
  TextEditingController semyearController = TextEditingController();

  late String selyear = 'السنة الاولى';

  Future _addSem() async {
    var data = {
      'year': semyearController.text,
      'number': translateNumAE(selection!),
    };

    try {
      final response = await CallApi().postData(data, '/api/semesters/create');

      if (response.statusCode == 409) {
        context.showSnackBar(
            'لا يمكنك بدأ كورس جديد, الرجاء انهاء ألكورس الحالي اولاً',
            isError: true);
      } else if (response.statusCode == 403) {
        context.showSnackBar('لا تملك الصلاحية', isError: true);
      } else {
        context.showSnackBar('تم بدأ الكورس بنجاح');
      }
      semyearController.text = '';
    } catch (e) {
      context.showSnackBar('احد الحقول فارغة او غير صحيحة', isError: true);
    }
  }

  Future _endSem() async {
    var data = {"year": '44'};

    try {
      final response = await CallApi().postData(data, '/api/semesters/end');

      if (response.statusCode == 409) {
        context.showSnackBar('الكورس الدراسي منتهي, الرجاء بدأ فصل دراسي جديد',
            isError: true);
      } else {
        context.showSnackBar('تم انهاء الكورس بنجاح');
      }
      semyearController.text = '';
    } catch (e) {
      context.showSnackBar('حدث خطأ ما, يرجى اعادة المحاولة', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          icon: const Icon(Icons.event_available_outlined),
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
                                                final yearReg =
                                                    RegExp(r"\d{4}-\d{4}");
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "لا يمكن ترك الحقل فارغاً";
                                                }
                                                if (!yearReg.hasMatch(value)) {
                                                  return "صيغة السنة غير صحيحة";
                                                }

                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'السنة الدراسية',
                                                hintText:
                                                    'صيغة الكتابة: 20xx-20xx',
                                                prefixIcon: const Icon(
                                                    Icons.date_range_outlined),
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
                                                    hint: const Text(
                                                        'رقم الكورس'),
                                                    value: selection,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selection =
                                                            newValue.toString();
                                                      });
                                                    },
                                                    items: _number.map((level) {
                                                      return DropdownMenuItem(
                                                        child: Text(level),
                                                        value: level,
                                                      );
                                                    }).toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return " الرجاء اختيار رقم الكورس";
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
                                          await _addSem();

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
                        value: 'انهاء الكورس الدراسي الحالي',
                        add: IconButton(
                          icon: const Icon(Icons.event_busy_outlined),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:
                                    const Text('انهاء الكورس الدراسي الحالي'),
                                content: const Text(
                                    ' هل انت متأكد؟ لن تتمكن من تعديل معلومات الكورس الدراسي هذا بعد انهاءه'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('الغاء')),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await _endSem();
                                        Navigator.pop(context);
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
