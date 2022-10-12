// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:schoolmanagement/components/buttoncards.dart';
// import 'package:schoolmanagement/module/extension.dart';

// import '../api.dart';
// import '../models/instructor.dart';

// class FileDash extends StatefulWidget {
//   const FileDash({Key? key}) : super(key: key);

//   @override
//   State<FileDash> createState() => _FileDashState();
// }

// class _FileDashState extends State<FileDash> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController nameController = TextEditingController();

//   final _intructor = TextEditingController();
//   late Future<List<Instructor>> futureAlbum;
//   List<Instructor> _data = [];

//   String? selection;
//   final _formKey = GlobalKey<FormState>();
//   String? selins;

//   Future<List<Instructor>> fetchAlbum() async {
//     final response = await CallApi().getData('/api/instructors');

//     if (response.statusCode == 200) {
//       final result = jsonDecode(response.body) as List;

//       return result.map((e) => Instructor.fromJson(e)).toList();
//     } else {
//       // If that call was not successful, throw an error.
//       throw Exception('Failed to load');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height / 1.2,
//         width: MediaQuery.of(context).size.width,
//         child: Card(
//           elevation: 5,
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 28.0, left: 18.0, right: 18.0),
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "",
//                     style: GoogleFonts.ibmPlexSansArabic(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ButtonCard(
//                         bezierCOlor: Colors.blue,
//                         value: 'رفع ماستر شيت كورس',
//                         add: IconButton(
//                           icon: const Icon(Icons.add),
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) => AlertDialog(
//                                 title: const Text('رفع ماستر شيت كورس'),
//                                 content: Column(
//                                   children: [
//                                     Form(
//                                       key: _formKey,
//                                       child: Column(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: SizedBox(
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               height: 40,
//                                               child: ButtonTheme(
//                                                 child: FutureBuilder<
//                                                     List<Instructor>>(
//                                                   future: futureAlbum,
//                                                   builder: (context, snapshot) {
//                                                     if (snapshot.hasData) {
//                                                       _data =
//                                                           snapshot.data ?? [];
//                                                       List<String> list = [];
//                                                       for (var i = 0;
//                                                           i < _data.length;
//                                                           i++) {
//                                                         list.add(
//                                                             _data[i].nameAr);
//                                                       }
//                                                       return StatefulBuilder(
//                                                         builder: (BuildContext
//                                                                 context,
//                                                             setState) {
//                                                           return DropdownButtonFormField<
//                                                               String>(
//                                                             isExpanded: true,
//                                                             validator: (value) {
//                                                               if (value ==
//                                                                   null) {
//                                                                 return " الرجاء  اختيار التدريسي ";
//                                                               }
//                                                               return null;
//                                                             },
//                                                             hint: const Text(
//                                                                 'اختيار التدريسي'),
//                                                             value: selins,
//                                                             onChanged:
//                                                                 (newValue) {
//                                                               setState(() {
//                                                                 selins = newValue
//                                                                     .toString();
//                                                               });
//                                                             },
//                                                             items:
//                                                                 list.map((ins) {
//                                                               return DropdownMenuItem(
//                                                                 child:
//                                                                     Text(ins),
//                                                                 value: ins,
//                                                               );
//                                                             }).toList(),
//                                                           );
//                                                         },
//                                                       );
//                                                     }
//                                                     return Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       children: const [
//                                                         CircularProgressIndicator(),
//                                                       ],
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 10),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 actions: [
//                                   ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text('الغاء')),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                         topColor: Colors.blue,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
