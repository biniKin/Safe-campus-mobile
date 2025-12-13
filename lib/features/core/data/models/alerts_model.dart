class AlertsModel {
  final String title;
  final String content;
  final DateTime time;
  final String status;

  AlertsModel({required this.title, required this.content, required this.time, required this.status});

  factory AlertsModel.fromJson(Map<String, dynamic> json){
    return AlertsModel(
      title: json['title'] ?? "Untitled", 
      content: json['content'], 
      time: DateTime.parse(json['time']),
      status: json['status']
    );
  }
}
