import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadBooks() async {
    QuerySnapshot querySnapshot = await _firestore.collection('library').get();
    setState(() {
      _books = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'code': doc['ID'].toString(),
          'bookName': doc['BookName'],
          'issueDate': (doc['IssueDate'] as Timestamp?)?.toDate(),
          'returnDate': (doc['ReturnDate'] as Timestamp?)?.toDate(),
          'status': doc['Status'],
        };
      }).toList();
      _filteredBooks = _books;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _filteredBooks = _books
          .where((book) =>
          book['bookName']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not Set';
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library', style: TextStyle(fontWeight: FontWeight.bold)),
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
                labelText: 'Search by Book Name',
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
                Text('Code', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Book name', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Issue date', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Return date', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(),

          // Book List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBooks.length,
              itemBuilder: (context, index) {
                final book = _filteredBooks[index];
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
                      Text(book['code']),
                      Text(book['bookName']),
                      Text(_formatDate(book['issueDate'])),
                      Text(_formatDate(book['returnDate'])),
                      Text(
                        book['status'] ? 'Available' : 'Not Available',
                        style: TextStyle(
                          color: book['status'] ? Colors.green : Colors.red,
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