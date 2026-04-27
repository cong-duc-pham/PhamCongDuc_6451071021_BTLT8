import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/log_controller.dart';
import 'data/repository/log_repository.dart';
import 'data/services/log_service.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = LogRepository();
  final service = LogService(repo);
  final controller = LogController(service);

  runApp(
    ChangeNotifierProvider.value(
      value: controller,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Load log ngay khi app khởi động
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogController>().loadLogs();
    });

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}