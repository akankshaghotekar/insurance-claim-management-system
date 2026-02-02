import 'package:flutter/material.dart';
import 'package:insurance_claim_management_system/models/insurance_claim.dart';
import 'package:insurance_claim_management_system/providers/claim_provider.dart';
import 'package:provider/provider.dart';

class EditClaimScreen extends StatefulWidget {
  final InsuranceClaim claim;
  final int index;

  const EditClaimScreen({super.key, required this.claim, required this.index});

  @override
  State<EditClaimScreen> createState() => _EditClaimScreenState();
}

class _EditClaimScreenState extends State<EditClaimScreen> {
  late String status;
  late TextEditingController settlementCtrl;

  @override
  void initState() {
    super.initState();
    status = widget.claim.status;
    settlementCtrl = TextEditingController(
      text: widget.claim.settlement.toString(),
    );
  }

  void _updateClaim() {
    final updatedClaim = InsuranceClaim(
      id: widget.claim.id,
      patientName: widget.claim.patientName,
      age: widget.claim.age,
      gender: widget.claim.gender,
      contactNumber: widget.claim.contactNumber,
      insuranceCompany: widget.claim.insuranceCompany,
      admissionDate: widget.claim.admissionDate,
      diagnosis: widget.claim.diagnosis,
      advance: widget.claim.advance,
      settlement: double.tryParse(settlementCtrl.text) ?? 0,
      status: status,
      bills: widget.claim.bills,
    );

    context.read<ClaimProvider>().updateClaim(widget.index, updatedClaim);

    Navigator.pop(context);
  }

  bool get _showSettlement =>
      status == 'Approved' || status == 'Partially Settled';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Claim')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Patient: ${widget.claim.patientName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField(
              value: status,
              decoration: const InputDecoration(labelText: 'Claim Status'),
              items: const [
                'Draft',
                'Submitted',
                'Approved',
                'Partially Settled',
                'Rejected',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => status = val!),
            ),

            if (_showSettlement) ...[
              const SizedBox(height: 15),
              TextField(
                controller: settlementCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Settlement Amount (Insurance)',
                ),
              ),
            ],

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateClaim,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
