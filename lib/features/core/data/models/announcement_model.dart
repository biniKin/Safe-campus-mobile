class AnnouncementModel {
  final String title;
  final String description;
  final String status;
  final DateTime time;

  AnnouncementModel({required this.title, required this.description, required this.time, required this.status});

  factory AnnouncementModel.fromJson(Map<String, dynamic> json){
    return AnnouncementModel(
      title: json['title'] ?? "Untitled", 
      description: json['content'] ?? "Description unavailable", 
      time: DateTime.parse(json['time']) ?? DateTime.now(),
      status: json['status'] ?? ''
    );
  }

}