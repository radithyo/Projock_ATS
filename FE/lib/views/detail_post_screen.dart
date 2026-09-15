import 'package:flutter/material.dart';

import 'edit_post_screen.dart';
import 'delete_post_screen.dart';

class DetailPostScreen extends StatelessWidget {
  final Map post;

  const DetailPostScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F),

      appBar: AppBar(
        backgroundColor: const Color(0xFFBDBDBD),
        foregroundColor: Colors.black,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Hapus'),
              ),
            ],
            onSelected: (value) async {
              if (value == 'edit') {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditPostScreen(post: post),
                  ),
                );

                if (result == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              }

              if (value == 'delete') {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DeletePostScreen(post: post),
                  ),
                );

                if (result == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              post['content'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}