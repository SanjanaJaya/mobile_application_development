import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore package
import 'librarystaff.dart'; // Import the librarystaff.dart file
import 'garbagestaff.dart'; // Import the garbagestaff.dart file
import 'streetstaff.dart'; // Import the streetstaff.dart file
import 'assesmentstaff.dart'; // Import the assesmentstaff.dart file
import 'staffprofile.dart'; // Import the staffprofile.dart file

class StaffPage extends StatefulWidget {
  final Map<String, dynamic> staffData;

  StaffPage({required this.staffData});

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  bool isAvailable = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    // Initialize availability status from the database
    _loadAvailabilityStatus();
  }

  // Load the current availability status from Firestore
  void _loadAvailabilityStatus() async {
    DocumentSnapshot doc = await _firestore
        .collection('staff')
        .doc(widget.staffData['uid'])
        .get();
    if (doc.exists) {
      setState(() {
        isAvailable = doc['availability'] == 'Available';
      });
    }
  }

  // Update the availability status in Firestore
  void _updateAvailabilityStatus(bool value) async {
    setState(() {
      isAvailable = value;
    });

    // Update the database
    await _firestore.collection('staff').doc(widget.staffData['uid']).update({
      'availability': value ? 'Available' : 'Absent',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Add padding to avoid edge
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(widget.staffData['image'] ?? ''),
                radius: 20, // Adjust the size of the profile icon
              ),
              onPressed: () {
                // Navigate to the StaffProfile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StaffProfile(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Main content centered in the middle of the page
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 2.0, // Increase the size of the switch
                    child: Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        _updateAvailabilityStatus(value); // Update Firestore
                      },
                      activeColor: Colors.green, // Green when "Available"
                      inactiveThumbColor: Colors.red, // Red when "Absent"
                      inactiveTrackColor: Colors.red.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    isAvailable ? 'Available' : 'Absent',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Welcome, ${widget.staffData['Name']}!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Library Management page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LibraryStaff(), // Redirect to LibraryStaff
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Library Management',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20), // Add some space between buttons
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Garbage Management page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GarbageStaff(), // Redirect to GarbageStaff
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Different color for distinction
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Garbage Management',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20), // Add some space between buttons
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Street Maintenance page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreetStaffPage(), // Redirect to StreetStaffPage
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Same color for consistency
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Street Maintenance',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20), // Add some space between buttons
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Assessment Staff page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssessmentStaffPage(), // Redirect to AssessmentStaffPage
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Same color for consistency
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Assessments',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}