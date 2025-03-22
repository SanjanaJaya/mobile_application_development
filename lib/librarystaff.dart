import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryStaff extends StatefulWidget {
  @override
  _LibraryStaffState createState() => _LibraryStaffState();
}

class _LibraryStaffState extends State<LibraryStaff> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LibraryRecord> _libraryRecords = [];
  List<LibraryRecord> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    QuerySnapshot querySnapshot = await _firestore.collection('library').get();
    setState(() {
      _libraryRecords = querySnapshot.docs.map((doc) {
        return LibraryRecord(
          id: doc.id, // Add document ID for updating details
          code: doc['ID'].toString(),
          bookName: doc['BookName'],
          issueDate: (doc['IssueDate'] as Timestamp).toDate(),
          returnDate: (doc['ReturnDate'] as Timestamp).toDate(),
          status: doc['Status'],
        );
      }).toList();
      _filteredRecords = _libraryRecords;
    });
  }

  void _addBook() async {
    final TextEditingController _bookNameController = TextEditingController();
    final TextEditingController _idController = TextEditingController();
    bool _status = false; // Default status is "Not Available"
    DateTime? _issueDate;
    DateTime? _returnDate;

    Future<void> _selectIssueDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _issueDate) {
        setState(() {
          _issueDate = picked;
        });
      }
    }

    Future<void> _selectReturnDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _issueDate ?? DateTime.now(),
        firstDate: _issueDate ?? DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _returnDate) {
        setState(() {
          _returnDate = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Book'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _bookNameController,
                  decoration: InputDecoration(labelText: 'Book Name'),
                ),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'ID'),
                  keyboardType: TextInputType.number,
                ),
                ListTile(
                  title: Text('Status: ${_status ? 'Available' : 'Not Available'}'),
                  trailing: Switch(
                    value: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
                ListTile(
                  title: Text(
                    _issueDate == null
                        ? 'Select Issue Date'
                        : 'Issue Date: ${_issueDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectIssueDate(context),
                ),
                ListTile(
                  title: Text(
                    _returnDate == null
                        ? 'Select Return Date'
                        : 'Return Date: ${_returnDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectReturnDate(context),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_bookNameController.text.isNotEmpty &&
                    _idController.text.isNotEmpty &&
                    _issueDate != null &&
                    _returnDate != null) {
                  await _firestore.collection('library').add({
                    'BookName': _bookNameController.text,
                    'ID': int.parse(_idController.text),
                    'IssueDate': Timestamp.fromDate(_issueDate!),
                    'ReturnDate': Timestamp.fromDate(_returnDate!),
                    'Status': _status,
                  });
                  _loadBooks();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields and select dates.'),
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editBook(LibraryRecord record) async {
    final TextEditingController _bookNameController =
    TextEditingController(text: record.bookName);
    final TextEditingController _idController =
    TextEditingController(text: record.code);
    bool _status = record.status; // Current status
    DateTime? _issueDate = record.issueDate;
    DateTime? _returnDate = record.returnDate;

    Future<void> _selectIssueDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _issueDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _issueDate) {
        setState(() {
          _issueDate = picked;
        });
      }
    }

    Future<void> _selectReturnDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _returnDate ?? DateTime.now(),
        firstDate: _issueDate ?? DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _returnDate) {
        setState(() {
          _returnDate = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Book'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _bookNameController,
                  decoration: InputDecoration(labelText: 'Book Name'),
                ),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'ID'),
                  keyboardType: TextInputType.number,
                ),
                ListTile(
                  title: Text('Status: ${_status ? 'Available' : 'Not Available'}'),
                  trailing: Switch(
                    value: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
                ListTile(
                  title: Text(
                    _issueDate == null
                        ? 'Select Issue Date'
                        : 'Issue Date: ${_issueDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectIssueDate(context),
                ),
                ListTile(
                  title: Text(
                    _returnDate == null
                        ? 'Select Return Date'
                        : 'Return Date: ${_returnDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectReturnDate(context),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_bookNameController.text.isNotEmpty &&
                    _idController.text.isNotEmpty &&
                    _issueDate != null &&
                    _returnDate != null) {
                  await _firestore.collection('library').doc(record.id).update({
                    'BookName': _bookNameController.text,
                    'ID': int.parse(_idController.text),
                    'IssueDate': Timestamp.fromDate(_issueDate!),
                    'ReturnDate': Timestamp.fromDate(_returnDate!),
                    'Status': _status,
                  });
                  _loadBooks();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields and select dates.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(_libraryRecords),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredRecords.length,
        itemBuilder: (context, index) {
          final record = _filteredRecords[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(record.bookName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Code: ${record.code}'),
                  Text('Issue Date: ${record.formattedIssueDate}'),
                  Text('Return Date: ${record.formattedReturnDate}'),
                  Text('Status: ${record.status ? 'Available' : 'Not Available'}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editBook(record);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF213555), // Custom color for the plus button
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate<String> {
  final List<LibraryRecord> libraryRecords;

  BookSearchDelegate(this.libraryRecords);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = libraryRecords
        .where((record) =>
        record.bookName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final record = results[index];
        return ListTile(
          title: Text(record.bookName),
          subtitle: Text('Code: ${record.code}'),
          onTap: () {
            close(context, record.bookName);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = libraryRecords
        .where((record) =>
        record.bookName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final record = suggestions[index];
        return ListTile(
          title: Text(record.bookName),
          subtitle: Text('Code: ${record.code}'),
          onTap: () {
            query = record.bookName;
            showResults(context);
          },
        );
      },
    );
  }
}

class LibraryRecord {
  String id; // Add document ID for updating details
  String code;
  String bookName;
  DateTime issueDate;
  DateTime returnDate;
  bool status; // Change to bool for status

  LibraryRecord({
    required this.id,
    required this.code,
    required this.bookName,
    required this.issueDate,
    required this.returnDate,
    required this.status,
  });

  String get formattedIssueDate => "${issueDate.day}/${issueDate.month}/${issueDate.year}";
  String get formattedReturnDate => "${returnDate.day}/${returnDate.month}/${returnDate.year}";
}