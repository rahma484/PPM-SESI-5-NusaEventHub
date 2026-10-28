class EventItem {
  final String id;
  final String title;
  final String speaker;
  final String speakerRole;
  final String category; // 'AI', 'Mobile', 'IoT', 'Cybersecurity'
  final String date;
  final String time;
  final String location;
  final String room;
  final int quota;
  final int registeredCount;
  final double price;
  final String description;
  final String posterUrl;
  final List<String> tags;

  const EventItem({
    required this.id,
    required this.title,
    required this.speaker,
    required this.speakerRole,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.room,
    required this.quota,
    required this.registeredCount,
    required this.price,
    required this.description,
    required this.posterUrl,
    required this.tags,
  });

  int get remainingQuota => quota - registeredCount;
  bool get isSoldOut => remainingQuota <= 0;
}