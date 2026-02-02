import 'package:flutter/material.dart';
import 'package:insurance_claim_management_system/screens/create_claim/create_claim_screen.dart';
import 'package:insurance_claim_management_system/screens/dashboard/dashboard_screen.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Medoc Health\nInsurance Claims',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),

          /// MENU ITEMS
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Create Claim'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateClaimScreen()),
              );
            },
          ),

          const Spacer(),

          /// FOOTER
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: const [
                Divider(),
                SizedBox(height: 8),
                Text(
                  'Hospital Insurance Claim Management',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Developed by Akanksha Ghotekar',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
