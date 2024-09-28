import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/data_model.dart';

class ApiService {
  final String apiUrl = 'https://ixifly.in/flutter/task1';

  Future<List<DataModel>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Decode the response body into a Map
      var jsonResponse = json.decode(response.body);

      // Access the 'data' key in the Map to get the list of events
      List<dynamic> data = jsonResponse['data'];

      // Parse the list of events into a list of DataModel
      return data.map((item) => DataModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
