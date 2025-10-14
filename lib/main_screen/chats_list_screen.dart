import 'package:flutter/material.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});
 
  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 30, // จำนวนรายการเพื่อให้เลื่อนยาว ๆ ได้
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.pink.shade100,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              title: Text('Chat Room ${index + 1}'),
              subtitle: const Text('Last message preview...'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
