import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'API/api_service.dart';
import 'Model/data_model.dart';
import 'Util/FilterData.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<DataModel>> futureData;
  String selectedFilter = 'Date';

  @override
  void initState() {
    super.initState();
    futureData = ApiService().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EaseMyDeal',
            style: TextStyle(
                fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureData = ApiService().fetchData();
          });
        },
        child: FutureBuilder<List<DataModel>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Data Available'));
            } else {
              List<DataModel> data = FilterLogic.filterData(snapshot.data!, selectedFilter); // Use the filtering function from the new file
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        icon: const Icon(Icons.filter_list_rounded),
                        iconEnabledColor: Colors.purple,
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurpleAccent,
                        ),
                        items: ['Date', 'Week', 'Month']
                            .map((filter) =>
                            DropdownMenuItem<String>(
                              child: Text(filter),
                              value: filter,
                            ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFilter = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(item.description,
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      DateFormat.yMMMd().format(item.date),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
