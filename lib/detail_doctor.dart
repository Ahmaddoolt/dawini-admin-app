import 'package:dawinadmin/models/static_values.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorDetailsPage extends StatefulWidget {
  final String doctorId;
  final Map<String, dynamic> doctorData;

  const DoctorDetailsPage({
    super.key,
    required this.doctorId,
    required this.doctorData,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.doctorData['Active'];
  }

  void toggleActiveStatus() async {
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.doctorId)
        .update({'Active': !isActive});

    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.doctorData['name']),
        backgroundColor: accentColor2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doctor Image
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    NetworkImage(widget.doctorData['profilePicture']),
              ),
            ),
            const SizedBox(height: 16),

            // Name and Specialization
            Text(
              widget.doctorData['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doctorData['specialization'],
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // Details Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(
                        Icons.email, "Email", widget.doctorData['email']),
                    _buildDetailRow(
                        Icons.phone, "Phone", widget.doctorData['phone']),
                    _buildDetailRow(Icons.location_on, "Location",
                        widget.doctorData['location']),
                    _buildDetailRow(Icons.sick, "Sickness",
                        widget.doctorData['sicknesses']),
                    _buildDetailRow(Icons.description, "Description",
                        widget.doctorData['description']),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Toggle Active Button
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: ElevatedButton(
                key: ValueKey<bool>(isActive),
                onPressed: toggleActiveStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? Colors.red : Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isActive ? 'Deactivate' : 'Activate',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: accentColor2),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
