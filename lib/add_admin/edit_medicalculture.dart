import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageMedicalCulturePage extends StatefulWidget {
  const ManageMedicalCulturePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageMedicalCulturePageState createState() =>
      _ManageMedicalCulturePageState();
}

class _ManageMedicalCulturePageState extends State<ManageMedicalCulturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text('Manage Medical Culture Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('MedicalCulture').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              var data = document.data() as Map<String, dynamic>;
              String documentId = document.id;
              String title = data['title'];
              String description = data['description'];

              return Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMedicalCulturePage(
                                documentId: documentId,
                                title: title,
                                description: description,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteEntry(documentId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _deleteEntry(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('MedicalCulture')
          .doc(documentId)
          .delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Data deleted successfully!'),
        duration: Duration(seconds: 2),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to delete data. Please try again later.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}

class EditMedicalCulturePage extends StatefulWidget {
  final String documentId;
  final String title;
  final String description;

  const EditMedicalCulturePage({
    required this.documentId,
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditMedicalCulturePageState createState() => _EditMedicalCulturePageState();
}

class _EditMedicalCulturePageState extends State<EditMedicalCulturePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: accentColor,
        title: const Text('Edit Medical Culture Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor, // Change to purple
              ),
              onPressed: () {
                _updateData();
              },
              child: const Text('Update Data'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateData() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('MedicalCulture')
            .doc(widget.documentId)
            .update({
          'title': title,
          'description': description,
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data updated successfully!'),
          duration: Duration(seconds: 2),
        ));

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to update data. Please try again later.'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
