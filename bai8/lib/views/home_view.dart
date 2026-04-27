import 'package:flutter/material.dart';
import 'item_view.dart';
import 'log_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nhật Ký Hoạt Động'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Dữ liệu (CRUD)'),
              Tab(text: 'Xem Log'),
            ],
          ),
        ),
        body: const Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [ItemView(), LogView()],
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(8),
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