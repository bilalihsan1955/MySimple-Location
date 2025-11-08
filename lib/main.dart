import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySimple Location',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const Homepage(judul: 'MySimple Location'),
    );
  }
}
