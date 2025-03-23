import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentStaffPage extends StatefulWidget {
  @override
  _AssessmentStaffPageState createState() => _AssessmentStaffPageState();
}

class _AssessmentStaffPageState extends State<AssessmentStaffPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to toggle payment status
  void _togglePaymentStatus(String userId, String currentStatus) async {
    String newStatus = currentStatus == 'Paid' ? 'Unpaid' : 'Paid';
    await _firestore.collection('user').doc(userId).update({
      'assesment': newStatus,
    });
  }

  // Function to update tax value
  void _updateTax(String userId, String newTax) async {
    if (newTax.isNotEmpty) {
      await _firestore.collection('user').doc(userId).update({
        'tax': newTax,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Assessments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              var userData = user.data() as Map<String, dynamic>;

              // Controller for editing tax
              TextEditingController taxController =
              TextEditingController(text: userData['tax'] ?? '');

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData['image']),
                  ),
                  title: Text(userData['Name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${userData['Email']}'),
                      Text('NIC: ${userData['NIC']}'),
                      Row(
                        children: [
                          Text('Tax: '),
                          SizedBox(
                            width: 150, // Adjusted width for better appearance
                            height: 40, // Adjusted height for better appearance
                            child: TextField(
                              controller: taxController,
                              decoration: InputDecoration(
                                prefixText: 'Rs. ', // Add "Rs." before the tax amount
                                hintText: 'Enter tax',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust padding
                              ),
                              onSubmitted: (value) {
                                _updateTax(user.id, value);
                              },
                            ),
                          ),
                        ],
                      ),
                      Text('Status: ${userData['assesment']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      userData['assesment'] == 'Paid'
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: userData['assesment'] == 'Paid'
                          ? Colors.green
                          : Colors.red,
                    ),
                    onPressed: () {
                      _togglePaymentStatus(user.id, userData['assesment']);
                    },
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