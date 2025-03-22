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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadBooks() async {
    QuerySnapshot querySnapshot = await _firestore.collection('library').get();
    setState(() {
      _libraryRecords = querySnapshot.docs.map((doc) {
        return LibraryRecord(
          id: doc.id,
          code: doc['ID'].toString(),
          bookName: doc['BookName'],
          issueDate: (doc['IssueDate'] as Timestamp?)?.toDate(),
          returnDate: (doc['ReturnDate'] as Timestamp?)?.toDate(),
          status: doc['Status'],
        );
      }).toList();
      // Sort books by ID (code) in ascending order
      _libraryRecords.sort((a, b) => int.parse(a.code).compareTo(int.parse(b.code)));
      _filteredRecords = _libraryRecords;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _filteredRecords = _libraryRecords
          .where((record) =>
          record.bookName.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
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
        return StatefulBuilder(
          builder: (context, setState) {
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
                            if (_status) {
                              _issueDate = null;
                              _returnDate = null;
                            }
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
                      onTap: _status ? null : () => _selectIssueDate(context),
                    ),
                    ListTile(
                      title: Text(
                        _returnDate == null
                            ? 'Select Return Date'
                            : 'Return Date: ${_returnDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: _status ? null : () => _selectReturnDate(context),
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
                    // Check if book name or ID already exists
                    bool bookNameExists = _libraryRecords.any((record) =>
                    record.bookName.toLowerCase() == _bookNameController.text.toLowerCase());
                    bool idExists = _libraryRecords.any((record) =>
                    record.code == _idController.text);

                    if (bookNameExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('A book with the same name already exists.'),
                        ),
                      );
                      return;
                    }

                    if (idExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('A book with the same ID already exists.'),
                        ),
                      );
                      return;
                    }

                    if (_bookNameController.text.isNotEmpty &&
                        _idController.text.isNotEmpty &&
                        (_status || (_issueDate != null && _returnDate != null))) {
                      await _firestore.collection('library').add({
                        'BookName': _bookNameController.text,
                        'ID': int.parse(_idController.text),
                        'IssueDate': _status ? null : Timestamp.fromDate(_issueDate!),
                        'ReturnDate': _status ? null : Timestamp.fromDate(_returnDate!),
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
      },
    );
  }

  void _editBook(LibraryRecord record) async {
    final TextEditingController _bookNameController =
    TextEditingController(text: record.bookName);
    final TextEditingController _idController =
    TextEditingController(text: record.code);
    bool _status = record.status;
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
        return StatefulBuilder(
          builder: (context, setState) {
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
                            if (_status) {
                              _issueDate = null;
                              _returnDate = null;
                            }
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
                      onTap: _status ? null : () => _selectIssueDate(context),
                    ),
                    ListTile(
                      title: Text(
                        _returnDate == null
                            ? 'Select Return Date'
                            : 'Return Date: ${_returnDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: _status ? null : () => _selectReturnDate(context),
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
                    // Check if book name or ID already exists (excluding the current book)
                    bool bookNameExists = _libraryRecords.any((r) =>
                    r.bookName.toLowerCase() == _bookNameController.text.toLowerCase() &&
                        r.id != record.id);
                    bool idExists = _libraryRecords.any((r) =>
                    r.code == _idController.text && r.id != record.id);

                    if (bookNameExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('A book with the same name already exists.'),
                        ),
                      );
                      return;
                    }

                    if (idExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('A book with the same ID already exists.'),
                        ),
                      );
                      return;
                    }

                    if (_bookNameController.text.isNotEmpty &&
                        _idController.text.isNotEmpty &&
                        (_status || (_issueDate != null && _returnDate != null))) {
                      await _firestore.collection('library').doc(record.id).update({
                        'BookName': _bookNameController.text,
                        'ID': int.parse(_idController.text),
                        'IssueDate': _status ? null : Timestamp.fromDate(_issueDate!),
                        'ReturnDate': _status ? null : Timestamp.fromDate(_returnDate!),
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
                TextButton(
                  onPressed: () async {
                    // Delete the book
                    await _firestore.collection('library').doc(record.id).delete();
                    _loadBooks();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Book Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Book Name')),
                  DataColumn(label: Text('Issue Date')),
                  DataColumn(label: Text('Return Date')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredRecords.map((record) {
                  return DataRow(
                    cells: [
                      DataCell(Text(record.code)),
                      DataCell(Text(record.bookName)),
                      DataCell(Text(record.formattedIssueDate)),
                      DataCell(Text(record.formattedReturnDate)),
                      DataCell(
                        Text(
                          record.status ? 'Available' : 'Not Available',
                          style: TextStyle(
                            color: record.status ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editBook(record);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF213555),
      ),
    );
  }
}

class LibraryRecord {
  String id;
  String code;
  String bookName;
  DateTime? issueDate;
  DateTime? returnDate;
  bool status;

  LibraryRecord({
    required this.id,
    required this.code,
    required this.bookName,
    required this.issueDate,
    required this.returnDate,
    required this.status,
  });

  String get formattedIssueDate => issueDate != null
      ? "${issueDate!.day}/${issueDate!.month}/${issueDate!.year}"
      : 'Not Set';

  String get formattedReturnDate => returnDate != null
      ? "${returnDate!.day}/${returnDate!.month}/${returnDate!.year}"
      : 'Not Set';
}