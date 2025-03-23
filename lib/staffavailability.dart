import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StaffAvailabilityPage extends StatefulWidget {
  const StaffAvailabilityPage({Key? key}) : super(key: key);

  @override
  _StaffAvailabilityPageState createState() => _StaffAvailabilityPageState();
}

class _StaffAvailabilityPageState extends State<StaffAvailabilityPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _staffList = [];
  List<Map<String, dynamic>> _filteredStaffList = [];

  @override
  void initState() {
    super.initState();
    _loadStaff();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadStaff() async {
    QuerySnapshot querySnapshot = await _firestore.collection('staff').get();
    setState(() {
      _staffList = querySnapshot.docs.map((doc) {
        return {
          'Name': doc['Name'],
          'Position': doc['position'],
          'Availability': doc['availability'],
        };
      }).toList();
      _filteredStaffList = _staffList; // Initialize filtered list with all staff
    });
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredStaffList = _staffList.where((staff) {
        final name = staff['Name']?.toString().toLowerCase() ?? '';
        final position = staff['Position']?.toString().toLowerCase() ?? '';
        return name.contains(query) || position.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Availability', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name or Position',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey[300],
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Position', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Availability', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(),

          // Staff List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStaffList.length,
              itemBuilder: (context, index) {
                final staff = _filteredStaffList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(staff['Name'] ?? ''),
                      Text(staff['Position'] ?? ''),
                      Text(
                        staff['Availability'] ?? '',
                        style: TextStyle(
                          color: staff['Availability'] == 'Available'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StaffAvailabilityPage(),
  ));
}