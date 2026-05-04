class Complaint {
  final String? id;
  final String title;
  final String description;
  final bool status;
  final String? npm;

  Complaint({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    this.npm,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      npm: json['npm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'npm': npm,
    };
  }
}
