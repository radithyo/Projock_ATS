import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPostScreen extends StatefulWidget {
  final Map post;

  const EditPostScreen({
    super.key,
    required this.post,
  });

  @override
  State<EditPostScreen> createState() =>
      _EditPostScreenState();
}

class _EditPostScreenState
    extends State<EditPostScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController authorController;

  List categories = [];
  int? selectedCategory;

  // Ambil kategori
  Future<void> getCategories() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/categories'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        categories = data['data'];
      });
    }
  }

  // Tambah kategori
  Future<void> addCategory() async {
    final categoryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Nama Kategori',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse(
                    'http://localhost:3000/api/categories',
                  ),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    'name': categoryController.text,
                  }),
                );

                if (response.statusCode == 201) {
                  if (!context.mounted) return;

                  Navigator.pop(context);

                  getCategories();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Update artikel
  Future<void> updatePost() async {
    final response = await http.put(
      Uri.parse(
        'http://localhost:3000/api/posts/${widget.post['id']}',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'category_id': selectedCategory,
        'title': titleController.text,
        'content': contentController.text,
        'author': authorController.text,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.post['title'],
    );

    contentController = TextEditingController(
      text: widget.post['content'],
    );

    authorController = TextEditingController(
      text: widget.post['author'],
    );

    selectedCategory = widget.post['category_id'];

    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F),

      appBar: AppBar(
        backgroundColor: const Color(0xFFBDBDBD),
        foregroundColor: Colors.black,
        title: const Text('Edit Artikel'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(14),

        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<int>(
                value: selectedCategory,
                dropdownColor: const Color(0xFF3A3A3A),
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'],
                    child: Text(
                      category['name'],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              TextButton.icon(
                onPressed: addCategory,
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text(
                  'Tambah Kategori',
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: authorController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: contentController,
                maxLines: 8,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Konten',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updatePost,
                  child: const Text(
                    'Simpan',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}