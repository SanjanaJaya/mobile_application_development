import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

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
              itemCount: 10, // Sample number of books
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Code'),
                      Text('Book name'),
                      Text('Issue date'),
                      Text('Return date'),
                      Text('Status'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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
