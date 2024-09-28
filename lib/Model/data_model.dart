class DataModel {
  final String title;
  final DateTime date;
  final String description;

  DataModel({required this.title, required this.date, required this.description});

  // Factory constructor to create a DataModel from JSON
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      title: json['title'],
      date: parseDate(json['date']),  // Using my custom date parser
      description: json['description'],
    );
  }

  //Creating Custom date parsing function as I was facing error in date format
  static DateTime parseDate(String dateString) {
    List<String> parts = dateString.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    return DateTime(year, month, day);
  }
}
