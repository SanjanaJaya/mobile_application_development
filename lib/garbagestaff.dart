import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GarbageStaff extends StatefulWidget {
  @override
  _GarbageStaffState createState() => _GarbageStaffState();
}

class _GarbageStaffState extends State<GarbageStaff> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garbage Management Schedule'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('garbage collection').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var garbageCollections = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Collection Zone',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Collection Type',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Time',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                  ),
                ),
              ],
              rows: garbageCollections.map<DataRow>((DocumentSnapshot document) {
                var data = document.data() as Map<String, dynamic>;
                var date = (data['Date'] as Timestamp).toDate();
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(data['Collection Zone'] ?? '')),
                    DataCell(Text(data['CollectionType'] ?? '')),
                    DataCell(Text(DateFormat('dd MMM yyyy').format(date))),
                    DataCell(Text(DateFormat('hh:mm a').format(date))),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeleteGarbageCollection(document.id);
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGarbageCollectionDialog();
        },
        backgroundColor: Color(0xFF213555), // Set the color to #213555
        child: Icon(Icons.add, color: Colors.white), // Set the plus icon to white
      ),
    );
  }

  void _confirmDeleteGarbageCollection(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Garbage Collection'),
          content: Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _deleteGarbageCollection(documentId); // Delete the entry
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteGarbageCollection(String documentId) {
    _firestore.collection('garbage collection').doc(documentId).delete();
  }

  void _showAddGarbageCollectionDialog() {
    String? selectedCollectionType;
    DateTime selectedDate = DateTime.now();
    final _zoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Garbage Collection'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _zoneController,
                  decoration: InputDecoration(labelText: 'Collection Zone'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCollectionType,
                  hint: Text('Select Collection Type'),
                  items: <String>['General Waste', 'Recyclables']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCollectionType = newValue;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text("Select Date"),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          selectedDate.hour,
                          selectedDate.minute,
                        );
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.blue),
                  title: Text("Select Time"),
                  subtitle: Text(DateFormat('hh:mm a').format(selectedDate)),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time != null) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_zoneController.text.isNotEmpty && selectedCollectionType != null) {
                  _firestore.collection('garbage collection').add({
                    'Collection Zone': _zoneController.text,
                    'CollectionType': selectedCollectionType,
                    'Date': Timestamp.fromDate(selectedDate),
                  }).then((value) {
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditGarbageCollectionDialog(String documentId, Map<String, dynamic> data) {
    String? selectedCollectionType = data['CollectionType'];
    DateTime selectedDate = (data['Date'] as Timestamp).toDate();
    final _zoneController = TextEditingController(text: data['Collection Zone']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Garbage Collection'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _zoneController,
                  decoration: InputDecoration(labelText: 'Collection Zone'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCollectionType,
                  hint: Text('Select Collection Type'),
                  items: <String>['General Waste', 'Recyclables']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCollectionType = newValue;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text("Select Date"),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          selectedDate.hour,
                          selectedDate.minute,
                        );
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.blue),
                  title: Text("Select Time"),
                  subtitle: Text(DateFormat('hh:mm a').format(selectedDate)),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time != null) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_zoneController.text.isNotEmpty && selectedCollectionType != null) {
                  _firestore.collection('garbage collection').doc(documentId).update({
                    'Collection Zone': _zoneController.text,
                    'CollectionType': selectedCollectionType,
                    'Date': Timestamp.fromDate(selectedDate),
                  }).then((value) {
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GarbageStaff(),
  ));
}