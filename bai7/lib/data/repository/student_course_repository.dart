import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';

class StudentCourseRepository {
  final List<Student> _students = [];
  final List<Course> _courses = [];
  final List<Enrollment> _enrollments = [];

  int _studentIdCounter = 1;
  int _courseIdCounter = 1;
  int _enrollmentIdCounter = 1;

  // Students
  List<Student> getStudents() => List.unmodifiable(_students);

  void addStudent(String name) {
    _students.add(Student(id: _studentIdCounter++, name: name));
  }

  // Courses
  List<Course> getCourses() => List.unmodifiable(_courses);

  void addCourse(String name) {
    _courses.add(Course(id: _courseIdCounter++, name: name));
  }

  // Enrollments
  List<Enrollment> getEnrollments() => List.unmodifiable(_enrollments);

  bool isEnrolled(int studentId, int courseId) {
    return _enrollments.any(
          (e) => e.studentId == studentId && e.courseId == courseId,
    );
  }

  void enroll(int studentId, int courseId) {
    if (!isEnrolled(studentId, courseId)) {
      _enrollments.add(Enrollment(
        id: _enrollmentIdCounter++,
        studentId: studentId,
        courseId: courseId,
      ));
    }
  }

  void unenroll(int studentId, int courseId) {
    _enrollments.removeWhere(
          (e) => e.studentId == studentId && e.courseId == courseId,
    );
  }

  List<Course> getCoursesOfStudent(int studentId) {
    final enrolledIds = _enrollments
        .where((e) => e.studentId == studentId)
        .map((e) => e.courseId)
        .toSet();
    return _courses.where((c) => enrolledIds.contains(c.id)).toList();
  }
}