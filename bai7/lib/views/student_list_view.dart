import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/student_course_controller.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addStudent(StudentCourseController controller) {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    controller.addStudent(name);
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StudentCourseController>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sinh viên',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _addStudent(controller),
                child: const Text('Thêm'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: controller.students.isEmpty
                ? const Center(child: Text('Chưa có sinh viên'))
                : ListView.builder(
              itemCount: controller.students.length,
              itemBuilder: (context, index) {
                final student = controller.students[index];
                final courses = controller.getCoursesOfStudent(student.id);
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text(
                    courses.isEmpty
                        ? 'Chưa đăng ký môn nào'
                        : courses.map((c) => c.name).join(', '),
                  ),
                  leading: Text('${student.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}