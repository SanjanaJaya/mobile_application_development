import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StreetPage extends StatefulWidget {
  const StreetPage({super.key});

  @override
  _StreetPageState createState() => _StreetPageState();
}

class _StreetPageState extends State<StreetPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Form fields
  String _location = '';
  String _issueType = '';
  String _description = '';
  String _urgencyLevel = '';
  String _contactNumber = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save data to Firestore
      await _firestore.collection('street_maintenance').add({
        'Location': _location,
        'IssueType': _issueType,
        'Description': _description,
        'UrgencyLevel': _urgencyLevel,
        'ContactNumber': _contactNumber,
        'Timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );

      // Clear the form
      _formKey.currentState!.reset();

      // Reset the state variables (optional, but recommended)
      setState(() {
        _location = '';
        _issueType = '';
        _description = '';
        _urgencyLevel = '';
        _contactNumber = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Street maintenance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Location
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              const SizedBox(height: 16),

              // Issue Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Issue Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Street Maintenance', child: Text('Street Maintenance')),
                  DropdownMenuItem(value: 'Lamppost Maintenance', child: Text('Lamppost Maintenance')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an issue type';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _issueType = value!;
                  });
                },
                onSaved: (value) {
                  _issueType = value!;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 16),

              // Urgency Level
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Urgency Level',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'High', child: Text('High')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an urgency level';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _urgencyLevel = value!;
                  });
                },
                onSaved: (value) {
                  _urgencyLevel = value!;
                },
              ),
              const SizedBox(height: 16),

              // Contact Number
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactNumber = value!;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF213555), // Change to #213555
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StreetPage(),
  ));
}