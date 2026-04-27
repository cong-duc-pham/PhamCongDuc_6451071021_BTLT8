import '../repository/student_course_repository.dart';
import '../models/student.dart';
import '../models/course.dart';

class StudentCourseService {
  final StudentCourseRepository _repo;

  StudentCourseService(this._repo);

  List<Student> getStudents() => _repo.getStudents();
  List<Course> getCourses() => _repo.getCourses();

  void addStudent(String name) => _repo.addStudent(name);
  void addCourse(String name) => _repo.addCourse(name);

  bool isEnrolled(int studentId, int courseId) =>
      _repo.isEnrolled(studentId, courseId);

  void toggleEnrollment(int studentId, int courseId) {
    if (_repo.isEnrolled(studentId, courseId)) {
      _repo.unenroll(studentId, courseId);
    } else {
      _repo.enroll(studentId, courseId);
    }
  }

  List<Course> getCoursesOfStudent(int studentId) =>
      _repo.getCoursesOfStudent(studentId);
}