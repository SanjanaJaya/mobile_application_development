import 'package:flutter/material.dart';

class StaffPage extends StatefulWidget {
  final Map<String, dynamic> staffData;

  StaffPage({required this.staffData});

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  bool isOnline = true;
  String _currentDateTime = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
  }

  void _updateDateTime() {
    setState(() {
      _currentDateTime = _getFormattedDateTime();
    });
    // Update the date and time every second
    Future.delayed(Duration(seconds: 1), _updateDateTime);
  }

  String _getFormattedDateTime() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _currentDateTime,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SwitchListTile(
              title: Text(
                isOnline ? 'Online' : 'Offline',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              value: isOnline,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  isOnline = value;
                });
              },
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Welcome, ${widget.staffData['Name']}!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Garbage Management',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(width: 20),
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Library Management',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          Spacer(),
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