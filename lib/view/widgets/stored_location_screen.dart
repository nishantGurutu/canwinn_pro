import 'package:flutter/material.dart';

class StoredLocationPage extends StatefulWidget {
  @override
  _StoredLocationPageState createState() => _StoredLocationPageState();
}

class _StoredLocationPageState extends State<StoredLocationPage> {
  List<Map<String, dynamic>> locationDataList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      // final data = await DatabaseHelper.instance
      //     .getLocationHistory(StorageHelper.getId().toString());
      // setState(() {
      //   locationDataList = data;
      //   isLoading = false;
      // });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load locations: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location History'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : locationDataList.isEmpty
                  ? Center(child: Text('No location data found'))
                  : ListView.builder(
                      itemCount: locationDataList.length,
                      itemBuilder: (context, index) {
                        final location = locationDataList[index];
                        return ListTile(
                          title: Text(
                              'Lat: ${location['latitude']}, Lon: ${location['longitude']}'),
                          subtitle: Text('Timestamp: ${location['timestamp']}'),
                          trailing: Text('Accuracy: ${location['accuracy']}'),
                        );
                      },
                    ),
    );
  }
}
