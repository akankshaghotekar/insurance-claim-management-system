import 'package:flutter/material.dart';
import 'package:insurance_claim_management_system/models/insurance_claim.dart';
import 'package:insurance_claim_management_system/providers/claim_provider.dart';
import 'package:provider/provider.dart';

class CreateClaimScreen extends StatefulWidget {
  const CreateClaimScreen({super.key});

  @override
  State<CreateClaimScreen> createState() => _CreateClaimScreenState();
}

class _CreateClaimScreenState extends State<CreateClaimScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final insuranceCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();
  final advanceCtrl = TextEditingController();
  final admissionDateCtrl = TextEditingController();

  String gender = 'Male';
  DateTime? admissionDate;

  /// SAVE CLAIM (Draft or Submitted)
  void _saveClaim(String status) {
    final claim = InsuranceClaim(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientName: nameCtrl.text.trim(),
      age: int.parse(ageCtrl.text),
      gender: gender,
      contactNumber: contactCtrl.text.trim(),
      insuranceCompany: insuranceCtrl.text.trim(),
      admissionDate: admissionDate!,
      diagnosis: reasonCtrl.text.trim(),
      advance: double.tryParse(advanceCtrl.text) ?? 0,

      settlement: 0,
      status: 'Draft',
      bills: [],
    );

    context.read<ClaimProvider>().addClaim(claim);
    Navigator.pop(context);
  }

  Future<bool> _onBackPressed() async {
    if (nameCtrl.text.isEmpty &&
        ageCtrl.text.isEmpty &&
        contactCtrl.text.isEmpty &&
        insuranceCtrl.text.isEmpty &&
        reasonCtrl.text.isEmpty) {
      return true;
    }

    final saveDraft = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Save as Draft?'),
        content: const Text(
          'You have entered some details. Do you want to save this claim as a draft?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NO'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('YES'),
          ),
        ],
      ),
    );

    if (saveDraft == true) {
      _saveClaim('Draft');
      return false;
    }
    return true;
  }

  /// DATE PICKER
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        admissionDate = picked;
        admissionDateCtrl.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Insurance Claim')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PATIENT DETAILS
                _sectionTitle('Patient Details'),
                _requiredField(controller: nameCtrl, label: 'Patient Name'),
                _requiredField(
                  controller: ageCtrl,
                  label: 'Age',
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField(
                  value: gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const ['Male', 'Female', 'Other']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => gender = val!,
                ),
                _requiredField(
                  controller: contactCtrl,
                  label: 'Contact Number',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 20),

                /// INSURANCE DETAILS
                _sectionTitle('Insurance Details'),
                _requiredField(
                  controller: insuranceCtrl,
                  label: 'Insurance Company',
                ),

                const SizedBox(height: 20),

                /// HOSPITAL DETAILS
                _sectionTitle('Hospital Details'),
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: admissionDateCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Admission Date',
                        hintText: 'Select date',
                      ),
                      validator: (_) =>
                          admissionDate == null ? 'Required' : null,
                    ),
                  ),
                ),
                _requiredField(
                  controller: reasonCtrl,
                  label: 'Reason for Admission (Diagnosis)',
                ),

                const SizedBox(height: 20),

                _sectionTitle('Payment (Optional)'),
                TextFormField(
                  controller: advanceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Advance Paid'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Enter valid numeric amount';
                    }
                    if (amount < 0) {
                      return 'Amount cannot be negative';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                /// SUBMIT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveClaim('Submitted');
                      }
                    },
                    child: const Text('Submit Claim'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// HELPERS
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _requiredField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
    );
  }
}
