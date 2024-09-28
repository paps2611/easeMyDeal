import '../Model/data_model.dart';

class FilterLogic {
  static List<DataModel> filterData(List<DataModel> data, String selectedFilter) {
    switch (selectedFilter) {
      case 'Week':
        return data.where((item) {
          final now = DateTime.now();
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(Duration(days: 6)); // End of the week is 6 days after start
          return item.date.isAfter(startOfWeek.subtract(Duration(days: 1))) && // Include start date
              item.date.isBefore(endOfWeek.add(Duration(days: 1))); // Include end date
        }).toList();

      case 'Month':
        return data.where((item) =>
        item.date.month == DateTime.now().month).toList();
      default:
        return data;
    }
  }
}
