import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/helper/db_helper.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Location location = Location();
  LocationData? _currentPosition;
  String _currentAddress = "";
  List<Map<String, dynamic>> locationData = [];

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  void _loadLocationData() async {
    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.getLocations();
    setState(() {
      locationData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Example"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: locationData.isEmpty
                ? Center(child: Text('No Data'))
                : ListView.builder(
                    itemCount: locationData.length,
                    itemBuilder: (context, index) {
                      return Text('${locationData[index]['latitude']}');
                    },
                  ),
          )
        ],
      ),
    );
  }
}
