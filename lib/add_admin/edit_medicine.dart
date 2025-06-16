import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageMedicinePage extends StatefulWidget {
  const ManageMedicinePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageMedicinePageState createState() => _ManageMedicinePageState();
}

class _ManageMedicinePageState extends State<ManageMedicinePage> {
  late Stream<QuerySnapshot> _medicineStream;

  @override
  void initState() {
    super.initState();
    _medicineStream =
        FirebaseFirestore.instance.collection('Medicine').snapshots();
  }

  void _deleteMedicine(String documentId) {
    FirebaseFirestore.instance.collection('Medicine').doc(documentId).delete();
  }

  void _editMedicine(String documentId, Map<String, dynamic> medicineData) {
    // Navigate to the edit medicine page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicinePage(
            documentId: documentId, medicineData: medicineData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text('Manage Medicine'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _medicineStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No medicine found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['medicine']['name']),
                subtitle: Text(data['medicine']['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editMedicine(document.id, data['medicine']);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this medicine?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteMedicine(document.id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditMedicinePage extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> medicineData;

  const EditMedicinePage(
      {super.key, required this.documentId, required this.medicineData});

  @override
  // ignore: library_private_types_in_public_api
  _EditMedicinePageState createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicineData['name']);
    _descriptionController =
        TextEditingController(text: widget.medicineData['description']);
    _typeController = TextEditingController(text: widget.medicineData['type']);
  }

  Future<void> _updateMedicine() async {
    String name = _nameController.text;
    String description = _descriptionController.text;
    String type = _typeController.text;

    try {
      await FirebaseFirestore.instance
          .collection('Medicine')
          .doc(widget.documentId)
          .update({
        'name': name,
        'description': description,
        'type': type,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine updated successfully')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Go back after updating
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update medicine: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text('Edit Medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor, // Change to purple
              ),
              onPressed: _updateMedicine,
              child: const Text('Update Medicine'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    super.dispose();
  }
}
