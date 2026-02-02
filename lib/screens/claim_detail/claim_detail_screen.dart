import 'package:flutter/material.dart';
import 'package:insurance_claim_management_system/models/insurance_claim.dart';
import 'package:insurance_claim_management_system/providers/claim_provider.dart';
import 'package:insurance_claim_management_system/screens/add_bill/add_bill_screen.dart';
import 'package:provider/provider.dart';

class ClaimDetailScreen extends StatelessWidget {
  final int index;

  const ClaimDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final claim = context.watch<ClaimProvider>().claims[index];
    final hasBills = claim.bills.isNotEmpty;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Claim Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              context,
              title: 'Patient Details',
              children: [
                _row('Patient Name', claim.patientName),
                _row('Age', claim.age.toString()),
                _row('Gender', claim.gender),
                _row('Contact', claim.contactNumber),
                _row('Insurance', claim.insuranceCompany),
                _row(
                  'Admission Date',
                  claim.admissionDate.toString().split(' ')[0],
                ),
                _row('Diagnosis', claim.diagnosis),
                _row('Status', claim.status),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bills',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Bills'),
                  onPressed: () async {
                    final BillItem? bill = await Navigator.push<BillItem>(
                      context,
                      MaterialPageRoute(builder: (_) => const AddBillScreen()),
                    );

                    if (bill != null) {
                      final updatedClaim = InsuranceClaim(
                        id: claim.id,
                        patientName: claim.patientName,
                        age: claim.age,
                        gender: claim.gender,
                        contactNumber: claim.contactNumber,
                        insuranceCompany: claim.insuranceCompany,
                        admissionDate: claim.admissionDate,
                        diagnosis: claim.diagnosis,
                        advance: claim.advance,
                        settlement: claim.settlement,
                        status: claim.status,
                        bills: [...claim.bills, bill],
                      );

                      context.read<ClaimProvider>().updateClaim(
                        index,
                        updatedClaim,
                      );
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (hasBills) ...[
              _section(
                context,
                title: 'Bill Details',
                children: [
                  ...List.generate(claim.bills.length, (billIndex) {
                    final bill = claim.bills[billIndex];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        title: Text(
                          bill.category,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          '${bill.description}\n${bill.date.toString().split(' ')[0]}',
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${bill.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(width: 8),

                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () async {
                                final updatedBill =
                                    await Navigator.push<BillItem>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AddBillScreen(bill: bill),
                                      ),
                                    );

                                if (updatedBill != null) {
                                  final updatedBills = [...claim.bills];
                                  updatedBills[billIndex] = updatedBill;

                                  final updatedClaim = InsuranceClaim(
                                    id: claim.id,
                                    patientName: claim.patientName,
                                    age: claim.age,
                                    gender: claim.gender,
                                    contactNumber: claim.contactNumber,
                                    insuranceCompany: claim.insuranceCompany,
                                    admissionDate: claim.admissionDate,
                                    diagnosis: claim.diagnosis,
                                    advance: claim.advance,
                                    settlement: claim.settlement,
                                    status: claim.status,
                                    bills: updatedBills,
                                  );

                                  context.read<ClaimProvider>().updateClaim(
                                    index,
                                    updatedClaim,
                                  );
                                }
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete Bill'),
                                    content: const Text(
                                      'Do you want to delete this bill?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  final updatedBills = [...claim.bills]
                                    ..removeAt(billIndex);

                                  final updatedClaim = InsuranceClaim(
                                    id: claim.id,
                                    patientName: claim.patientName,
                                    age: claim.age,
                                    gender: claim.gender,
                                    contactNumber: claim.contactNumber,
                                    insuranceCompany: claim.insuranceCompany,
                                    admissionDate: claim.admissionDate,
                                    diagnosis: claim.diagnosis,
                                    advance: claim.advance,
                                    settlement: claim.settlement,
                                    status: claim.status,
                                    bills: updatedBills,
                                  );

                                  context.read<ClaimProvider>().updateClaim(
                                    index,
                                    updatedClaim,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 16),

              _section(
                context,
                title: 'Summary',
                children: [
                  _row('Total Bill', '₹${claim.totalBill.toStringAsFixed(2)}'),
                  _row('Advance Paid', '₹${claim.advance.toStringAsFixed(2)}'),
                  if (claim.status == 'Approved' ||
                      claim.status == 'Partially Settled')
                    _row(
                      'Insurance Settlement',
                      '₹${claim.settlement.toStringAsFixed(2)}',
                    ),

                  const Divider(),

                  _row(
                    'Pending Amount',
                    '₹${claim.pendingAmount.toStringAsFixed(2)}',
                    highlight: true,
                  ),

                  if (claim.refundAmount > 0)
                    _row(
                      'Refund Amount',
                      '₹${claim.refundAmount.toStringAsFixed(2)}',
                      highlight: true,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              fontSize: highlight ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
