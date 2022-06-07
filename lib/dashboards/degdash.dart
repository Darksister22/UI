import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schoolmanagement/components/buttoncards.dart';
import 'package:schoolmanagement/components/utils.dart';
import 'package:schoolmanagement/mains/deg_cur.dart';

import '../api.dart';
import '../mains/deg_all.dart';

class DegDash extends StatefulWidget {
  const DegDash({Key? key}) : super(key: key);

  @override
  State<DegDash> createState() => _DegDashState();
}

class _DegDashState extends State<DegDash> {
  bool isLoading = true;
  Future _caclDeg() async {
    var data = {};

    try {
      final response = await CallApi().postData(data, '/api/degrees/cacl');
      if (response.statusCode == 200) {
        isLoading = false;
      }
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
                    children: [
                      ButtonCard(
                        bezierCOlor: Colors.lightBlue,
                        value: 'عبور الطلاب',
                        add: IconButton(
                          icon: const Icon(Icons.calculate_outlined),
                          onPressed: () async {},
                        ),
                        topColor: Colors.lightBlue,
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
                        value: 'عرض درجات الكورس الحالي',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () async {
                            await _caclDeg();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DegCur(),
                              ),
                            );
                            context.showSnackBar('تم حساب درجات الكورس بنجاح');
                          },
                        ),
                        topColor: Colors.greenAccent,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ButtonCard(
                        bezierCOlor: Colors.orangeAccent,
                        value: 'عرض درجات السنوات السابقة',
                        add: IconButton(
                          icon: const Icon(Icons.person_outline_outlined),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DegAll(),
                              ),
                            );
                          },
                        ),
                        topColor: Colors.orangeAccent,
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
