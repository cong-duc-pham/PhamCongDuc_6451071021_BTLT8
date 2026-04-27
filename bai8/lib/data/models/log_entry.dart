class LogEntry {
  final int? id;
  final String action;
  final String time;

  LogEntry({this.id, required this.action, required this.time});

  Map<String, dynamic> toMap() => {'action': action, 'time': time};

  factory LogEntry.fromMap(Map<String, dynamic> map) => LogEntry(
    id: map['id'],
    action: map['action'],
    time: map['time'],
  );
}