import 'package:flutter/material.dart';
import 'student_list_view.dart';
import 'course_list_view.dart';
import 'enrollment_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý Sinh Viên - Môn Học'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sinh Viên'),
              Tab(text: 'Môn Học'),
              Tab(text: 'Đăng Ký'),
            ],
          ),
        ),
        body: const Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  StudentListView(),
                  CourseListView(),
                  EnrollmentView(),
                ],
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Phạm Công Đức - 6451071021',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}