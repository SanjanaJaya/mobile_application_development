import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Import your LoginScreen

class StaffProfile extends StatefulWidget {
  @override
  _StaffProfileState createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? staffData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStaffData();
  }

  Future<void> _fetchStaffData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot staffDoc =
      await _firestore.collection('staff').doc(user.uid).get();
      if (staffDoc.exists) {
        setState(() {
          staffData = staffDoc.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editField(String field, String currentValue) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final TextEditingController controller =
      TextEditingController(text: currentValue);
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new $field'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await _firestore
                      .collection('staff')
                      .doc(user.uid)
                      .update({field: controller.text});
                  _fetchStaffData(); // Refresh data after update
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(staffData!['image'] ?? ''),
                ),
                IconButton(
                  icon: Icon(Icons.edit, size: 20),
                  onPressed: () {
                    // Add functionality to edit the profile image
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                staffData!['Name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, size: 20),
                onPressed: () => _editField('Name', staffData!['Name']),
              ),
            ),
            ListTile(
              leading: Icon(Icons.card_travel),
              title: Text(staffData!['NIC']),
              trailing: IconButton(
                icon: Icon(Icons.edit, size: 20),
                onPressed: () => _editField('NIC', staffData!['NIC']),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(staffData!['Email']),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut(); // Sign out the user
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()), // Replace with LoginScreen
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}