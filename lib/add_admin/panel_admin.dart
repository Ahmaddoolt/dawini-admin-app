import 'package:flutter/material.dart';
import 'package:dawinadmin/add_admin/panel_alternativemedicine.dart';
import 'package:dawinadmin/add_admin/panel_medicalculture.dart';
import 'package:dawinadmin/add_admin/panel_medicine.dart';
import 'package:dawinadmin/add_admin/panel_sicken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../doctors_list.dart';
import '../login.dart';
import '../models/static_values.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    const FlutterSecureStorage storage = FlutterSecureStorage();

    Future<void> logout() async {
      await storage.delete(key: 'saved_email');
      await storage.delete(key: 'saved_pass');
      await storage.delete(key: 'remb');

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );

      // Navigate back to login screen
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Dawini Admin Panel'),
        backgroundColor: accentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: logout, // Call logout method
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/admino.gif',
                height: 250,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildAdminCard(
                    context,
                    title: 'Manage Diseases',
                    icon: Icons.local_hospital,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PanelSicken()),
                    ),
                    borderColor: mainColor2,
                  ),
                  _buildAdminCard(
                    context,
                    title: 'Manage Medicines',
                    icon: Icons.medical_services,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MedicinePanel()),
                    ),
                    borderColor: mainColor2,
                  ),
                  _buildAdminCard(
                    context,
                    title: 'Medical Culture',
                    icon: Icons.book,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PanelMedicalCulture()),
                    ),
                    borderColor: mainColor2,
                  ),
                  _buildAdminCard(
                    context,
                    title: 'Alternative Medicine',
                    icon: Icons.healing,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PanelAlternative()),
                    ),
                    borderColor: mainColor2,
                  ),
                  _buildAdminCard(
                    context,
                    title: 'Active Doctors',
                    icon: Icons.admin_panel_settings,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorListPage()),
                    ),
                    borderColor: mainColor2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap,
      required Color borderColor}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: borderColor, width: 2.0),
      ),
      elevation: 4.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(icon, size: 30, color: mainColor2),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: accentColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: accentColor),
          ),
        ),
      ),
    );
  }
}
