import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detail_doctor.dart';

class DoctorListPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
          backgroundColor: accentColor,
          centerTitle: true,
          title: const Text('Doctors List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No doctors found'));
          }

          var doctors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              var doctor = doctors[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(doctor['profilePicture']),
                ),
                title: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      doctor['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star_rate),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      doctor['specialization'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: Icon(
                  doctor['Active'] ? Icons.check_circle : Icons.cancel,
                  color: doctor['Active'] ? Colors.green : Colors.red,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsPage(
                        doctorId: doctor.id,
                        doctorData: doctor.data() as Map<String, dynamic>,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
