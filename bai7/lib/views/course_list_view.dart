import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/student_course_controller.dart';

class CourseListView extends StatefulWidget {
  const CourseListView({super.key});

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addCourse(StudentCourseController controller) {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    controller.addCourse(name);
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
                    labelText: 'Tên môn học',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _addCourse(controller),
                child: const Text('Thêm'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: controller.courses.isEmpty
                ? const Center(child: Text('Chưa có môn học'))
                : ListView.builder(
              itemCount: controller.courses.length,
              itemBuilder: (context, index) {
                final course = controller.courses[index];
                return ListTile(
                  leading: Text('${course.id}'),
                  title: Text(course.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}