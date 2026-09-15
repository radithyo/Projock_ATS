import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeletePostScreen extends StatelessWidget {
  final Map post;

  const DeletePostScreen({
    super.key,
    required this.post,
  });

  Future<void> deletePost(BuildContext context) async {
    final response = await http.delete(
      Uri.parse(
        'http://localhost:3000/api/posts/${post['id']}',
      ),
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F),

      appBar: AppBar(
        backgroundColor: const Color(0xFFBDBDBD),
        foregroundColor: Colors.black,
        title: const Text('Hapus Artikel'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Yakin mau hapus artikel ini?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              post['title'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  deletePost(context);
                },
                child: const Text('Hapus'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}