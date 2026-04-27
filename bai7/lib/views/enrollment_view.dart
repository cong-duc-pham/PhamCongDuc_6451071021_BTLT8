import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/student_course_controller.dart';
import '../data/models/student.dart';

class EnrollmentView extends StatefulWidget {
  const EnrollmentView({super.key});

  @override
  State<EnrollmentView> createState() => _EnrollmentViewState();
}

class _EnrollmentViewState extends State<EnrollmentView> {
  Student? _selectedStudent;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StudentCourseController>();

    // Reset nếu student bị xoá
    if (_selectedStudent != null &&
        !controller.students.any((s) => s.id == _selectedStudent!.id)) {
      _selectedStudent = null;
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chọn sinh viên:', style: TextStyle(fontSize: 15)),
          const SizedBox(height: 6),
          DropdownButtonFormField<Student>(
            value: _selectedStudent,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: const Text('-- Chọn sinh viên --'),
            items: controller.students
                .map((s) => DropdownMenuItem(
              value: s,
              child: Text(s.name),
            ))
                .toList(),
            onChanged: (val) => setState(() => _selectedStudent = val),
          ),
          const SizedBox(height: 16),
          if (_selectedStudent != null) ...[
            Text(
              'Đăng ký môn cho: ${_selectedStudent!.name}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: controller.courses.isEmpty
                  ? const Center(child: Text('Chưa có môn học nào'))
                  : ListView.builder(
                itemCount: controller.courses.length,
                itemBuilder: (context, index) {
                  final course = controller.courses[index];
                  final enrolled = controller.isEnrolled(
                      _selectedStudent!.id, course.id);
                  return CheckboxListTile(
                    title: Text(course.name),
                    value: enrolled,
                    onChanged: (_) => controller.toggleEnrollment(
                        _selectedStudent!.id, course.id),
                  );
                },
              ),
            ),
          ] else
            const Expanded(
              child: Center(child: Text('Vui lòng chọn sinh viên')),
            ),
        ],
      ),
    );
  }
}