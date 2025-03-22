import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc =
      await _firestore.collection('user').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
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
                      .collection('user')
                      .doc(user.uid)
                      .update({field: controller.text});
                  _fetchUserData(); // Refresh data after update
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

    final String dob = userData!['DOB'] != null
        ? DateFormat('dd MMMM yyyy').format((userData!['DOB'] as Timestamp).toDate())
        : 'Not available';

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
                  backgroundImage: NetworkImage(userData!['image']),
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
                userData!['Name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, size: 20),
                onPressed: () => _editField('Name', userData!['Name']),
              ),
            ),
            ListTile(
              leading: Icon(Icons.numbers),
              title: Text(userData!['NIC']),
              trailing: IconButton(
                icon: Icon(Icons.edit, size: 20),
                onPressed: () => _editField('NIC', userData!['NIC']),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(userData!['Email']),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(userData!['Phone_number']),
              trailing: IconButton(
                icon: Icon(Icons.edit, size: 20),
                onPressed: () => _editField('Phone_number', userData!['Phone_number']),
              ),
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text(dob),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}