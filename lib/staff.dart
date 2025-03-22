import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore package

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
                      // Navigate to Garbage Management page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GarbageManagementPage(),
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
                      'Garbage Management',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Library Management page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LibraryManagementPage(),
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
                ],
              ),
            ),
          ),
          // Bottom navigation bar
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.home, size: 30),
                  onPressed: () {
                    // Navigate to Home page
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, size: 30),
                  onPressed: () {
                    // Navigate to Profile page
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for Garbage Management Page
class GarbageManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garbage Management'),
      ),
      body: Center(
        child: Text('Garbage Management Page'),
      ),
    );
  }
}

// Placeholder for Library Management Page
class LibraryManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Management'),
      ),
      body: Center(
        child: Text('Library Management Page'),
      ),
    );
  }
}