import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StreetStaffPage extends StatefulWidget {
  @override
  _StreetStaffPageState createState() => _StreetStaffPageState();
}

class _StreetStaffPageState extends State<StreetStaffPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Street Maintenance Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('street_maintenance').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index].data() as Map<String, dynamic>;
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StreetStaffPage(),
  ));
}