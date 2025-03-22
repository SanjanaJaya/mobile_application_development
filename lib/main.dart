import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mad/contact.dart';
import 'login.dart'; // Import AuthScreen
import 'garbage.dart';
import 'health.dart'; // Import HealthPage
import 'profile.dart'; // Import ProfileScreen
import 'assesment.dart'; // Import AssessmentPage
import 'street.dart'; // Import StreetPage
import 'library.dart'; // Import LibraryPage
import 'contact.dart.';

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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
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
                // Navigate to ProfileScreen when the profile picture is clicked
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              accountName: Text(
                userData['Name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                userData['Email'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(userData['image']),
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.black),
              title: Text('Location'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail, color: Colors.black),
              title: Text('Contact us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: Colors.black),
              title: Text('Help and FAQs'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search here',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  'Hello,', // First line
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['Name'], // Second line
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.9, // Adjust this value to give more height to the children
              children: [
                ServiceIcon('img/book.png', 'Library', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LibraryPage()),
                  );
                }),
                ServiceIcon('img/garbage.png', 'Garbage', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GarbagePage()),
                  );
                }),
                ServiceIcon('img/assessment.png', 'Assessment', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AssessmentPage()),
                  );
                }),
                ServiceIcon('img/street.png', 'Street Maintenance', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StreetPage()),
                  );
                }),
                ServiceIcon('img/staff.png', 'Staff Availability', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HealthPage()),
                  );
                }),
                ServiceIcon('img/contact.png', 'Contact Us'),
                ServiceIcon('img/location.png', 'Location'),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(LucideIcons.bell), label: ''),
        ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // Fixed height to ensure enough space
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
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
              child: Image.asset(imagePath, width: 60, height: 60),
            ),
            SizedBox(height: 10),
            Flexible( // Ensure text doesn't overflow
              child: Text(
                label,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}