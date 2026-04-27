import 'package:flutter/material.dart';
import '../data/services/student_course_service.dart';
import '../data/models/student.dart';
import '../data/models/course.dart';

class StudentCourseController extends ChangeNotifier {
  final StudentCourseService _service;

  StudentCourseController(this._service);

  List<Student> get students => _service.getStudents();
  List<Course> get courses => _service.getCourses();

  void addStudent(String name) {
    _service.addStudent(name);
    notifyListeners();
  }

  void addCourse(String name) {
    _service.addCourse(name);
    notifyListeners();
  }

  bool isEnrolled(int studentId, int courseId) =>
      _service.isEnrolled(studentId, courseId);

  void toggleEnrollment(int studentId, int courseId) {
    _service.toggleEnrollment(studentId, courseId);
    notifyListeners();
  }

  List<Course> getCoursesOfStudent(int studentId) =>
      _service.getCoursesOfStudent(studentId);
}