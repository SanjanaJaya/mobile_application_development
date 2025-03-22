import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'package:lucide_icons/lucide_icons.dart';
import 'login.dart'; // Import AuthScreen
import 'garbage.dart';
import 'health.dart'; // Import HealthPage

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
            child: CircleAvatar(
              backgroundImage: AssetImage('img/profile.png'),
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
                'Nethmina Medagedara',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'saangip17@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('img/profile.png'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Services', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 80),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              children: [
                ServiceIcon('img/book.png', 'Library'),
                ServiceIcon('img/trash.png', 'Garbage', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GarbagePage()),
                  );
                }),
                ServiceIcon('img/analytics.png', 'Analytics'),
                ServiceIcon('img/medical.png', 'Medical'),
                ServiceIcon('img/medical.png', 'Health', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HealthPage()), // Navigate to HealthPage
                  );
                }),
                ServiceIcon('img/medical.png', 'Pakaya'),
                ServiceIcon('img/medical.png', 'Support'),
              ],
            ),
            SizedBox(height: 30),
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
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
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
            child: Image.asset(imagePath, width: 40, height: 40),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}