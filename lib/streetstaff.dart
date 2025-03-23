import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StreetStaffPage extends StatefulWidget {
  @override
  _StreetStaffPageState createState() => _StreetStaffPageState();
}

class _StreetStaffPageState extends State<StreetStaffPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _selectedDate; // Selected date for filtering
  List<QueryDocumentSnapshot> _allRequests = []; // All requests from Firestore
  List<QueryDocumentSnapshot> _filteredRequests = []; // Filtered requests based on date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Street Maintenance Requests'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _pickDate, // Open date picker to select a date
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedDate != null)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Filtering by: ${DateFormat('dd MMMM yyyy').format(_selectedDate!)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _clearFilter, // Clear the filter
                    child: Text('Clear Filter'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('street_maintenance').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                _allRequests = snapshot.data!.docs;
                _filterRequests(); // Apply filtering logic

                return ListView.builder(
                  itemCount: _filteredRequests.length,
                  itemBuilder: (context, index) {
                    var request = _filteredRequests[index].data() as Map<String, dynamic>;
                    var timestamp = request['Timestamp'] as Timestamp;
                    var formattedDate = DateFormat('dd MMMM yyyy, hh:mm a')
                        .format(timestamp.toDate());

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(request['IssueType']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${request['Description']}'),
                            Text('Location: ${request['Location']}'),
                            Text('Contact: ${request['ContactNumber']}'),
                            Text('Urgency: ${request['UrgencyLevel']}'),
                            Text('Date & Time: $formattedDate'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Open date picker to select a date
  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Clear the selected date filter
  void _clearFilter() {
    setState(() {
      _selectedDate = null;
    });
  }

  // Filter requests based on the selected date
  void _filterRequests() {
    if (_selectedDate == null) {
      _filteredRequests = _allRequests; // Show all requests if no date is selected
    } else {
      _filteredRequests = _allRequests.where((request) {
        var requestDate = (request['Timestamp'] as Timestamp).toDate();
        return requestDate.year == _selectedDate!.year &&
            requestDate.month == _selectedDate!.month &&
            requestDate.day == _selectedDate!.day;
      }).toList();
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: StreetStaffPage(),
  ));
}