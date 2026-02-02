import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insurance_claim_management_system/models/insurance_claim.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimProvider extends ChangeNotifier {
  List<InsuranceClaim> _claims = [];

  List<InsuranceClaim> get claims => _claims;

  ClaimProvider() {
    loadClaims();
  }

  void addClaim(InsuranceClaim claim) {
    _claims.add(claim);
    saveClaims();
    notifyListeners();
  }

  void updateClaim(int index, InsuranceClaim claim) {
    _claims[index] = claim;
    saveClaims();
    notifyListeners();
  }

  Future<void> saveClaims() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _claims.map((c) => c.toJson()).toList();
    prefs.setString('claims', jsonEncode(data));
  }

  Future<void> loadClaims() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('claims');
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      _claims = decoded.map((e) => InsuranceClaim.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
