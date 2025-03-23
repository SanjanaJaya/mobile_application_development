import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white, // White background
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF213555), // Box color #213555
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // CitySync Logo
                    Image.asset(
                      'img/logo.png', // Replace with your logo path
                      height: 160,
                      width: 160,
                    ),
                    SizedBox(height: 20),
                    // Contact Us Title
                    Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Email with Icon
                    _buildContactInfo(
                      icon: Icons.email,
                      text: 'citysync@gmail.com',
                    ),
                    SizedBox(height: 10),
                    // Phone with Icon
                    _buildContactInfo(
                      icon: Icons.phone,
                      text: '+94 71#######',
                    ),
                    SizedBox(height: 20),
                    // For Complaints Title
                    Text(
                      'For Complaints',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Complaints Email with Icon
                    _buildContactInfo(
                      icon: Icons.email,
                      text: 'citycomplaints@gmail.com',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build contact info with icons
  Widget _buildContactInfo({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}