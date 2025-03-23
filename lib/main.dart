import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'login.dart'; // Import AuthScreen
import 'garbage.dart';
import 'profile.dart'; // Import ProfileScreen
import 'assesment.dart'; // Import AssessmentPage
import 'street.dart'; // Import StreetPage
import 'library.dart'; // Import LibraryPage
import 'staffavailability.dart';
import 'contact.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(), // Set AuthScreen as the initial screen
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  DashboardScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.transparent),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(userData['image']),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05), // Use percentage of screen height
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['Name'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.08, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.08), // Use percentage of screen height
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              children: [
                ServiceIcon('img/book.png', 'Library', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LibraryPage()),
                  );
                }),
                ServiceIcon('img/garbage.png', 'Garbage Schedule', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GarbagePage()),
                  );
                }),
                ServiceIcon('img/assessment.png', 'Assessments', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AssessmentPage()),
                  );
                }),
                ServiceIcon('img/street.png', 'Maintenances', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StreetPage()),
                  );
                }),
                ServiceIcon('img/staff.png', 'Staff Availability', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StaffAvailabilityPage()),
                  );
                }),
                ServiceIcon('img/contact.png', 'Contact Us', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsScreen()),
                  );
                }),
              ],
            ),
            SizedBox(height: screenHeight * 0.04), // Use percentage of screen height
          ],
        ),
      ),
    );
  }
}

class ServiceIcon extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback? onTap;

  ServiceIcon(this.imagePath, this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenWidth * 0.3, // Responsive height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(imagePath, width: screenWidth * 0.15, height: screenWidth * 0.15), // Responsive image size
            ),
            SizedBox(height: screenWidth * 0.02), // Responsive spacing
            Flexible(
              child: Text(
                label,
                style: TextStyle(fontSize: screenWidth * 0.035), // Responsive font size
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}