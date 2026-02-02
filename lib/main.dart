import 'package:flutter/material.dart';
import 'package:insurance_claim_management_system/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'providers/claim_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ClaimProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Insurance Claims',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardScreen(),
    );
  }
}
