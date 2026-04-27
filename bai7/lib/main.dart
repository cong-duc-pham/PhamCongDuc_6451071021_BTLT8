import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/student_course_controller.dart';
import 'data/repository/student_course_repository.dart';
import 'data/services/student_course_service.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StudentCourseController(
        StudentCourseService(StudentCourseRepository()),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}