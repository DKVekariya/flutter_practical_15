
// University Model
class University {
  final String name;
  final String country;
  final String webPage;

  University({
    required this.name,
    required this.country,
    required this.webPage,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      webPage: (json['web_pages'] as List).first ?? '',
    );
  }
}