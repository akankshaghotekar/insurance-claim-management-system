import 'package:flutter/material.dart';
import 'package:insurance_claim_management_system/providers/claim_provider.dart';
import 'package:insurance_claim_management_system/screens/claim_detail/claim_detail_screen.dart';
import 'package:insurance_claim_management_system/screens/create_claim/edit_claim_screen.dart';
import 'package:insurance_claim_management_system/widgets/common_drawer.dart';
import 'package:insurance_claim_management_system/widgets/status_chip.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClaimProvider>();

    final filteredClaims = provider.claims.asMap().entries.where((entry) {
      final index = entry.key;
      final claim = entry.value;
      final query = searchQuery.toLowerCase().trim();

      if (query.isEmpty) return true;

      return claim.patientName.toLowerCase().contains(query) ||
          claim.contactNumber.contains(query) ||
          claim.status.toLowerCase().contains(query) ||
          (index + 1).toString() == query;
    }).toList();

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Claims Dashboard')),
      drawer: const CommonDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insurance Claims',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                                'Search by patient name or contact number',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() => searchQuery = value);
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// TABLE AREA
                      Expanded(
                        child: filteredClaims.isEmpty
                            ? const Center(
                                child: Text(
                                  'No claims',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: DataTable(
                                    columnSpacing: 40,
                                    horizontalMargin: 24,
                                    headingRowHeight: 56,
                                    dataRowHeight: 60,
                                    dividerThickness: 1.2,
                                    headingRowColor: MaterialStateProperty.all(
                                      Colors.grey.shade300,
                                    ),
                                    headingTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    columns: const [
                                      DataColumn(label: Text('Sr. No')),
                                      DataColumn(label: Text('Patient Name')),
                                      DataColumn(label: Text('Contact')),
                                      DataColumn(label: Text('Advance')),
                                      DataColumn(label: Text('Total Bill')),
                                      DataColumn(label: Text('Pending')),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('View')),
                                      DataColumn(label: Text('Edit')),
                                    ],
                                    rows: List.generate(filteredClaims.length, (
                                      index,
                                    ) {
                                      final originalIndex =
                                          filteredClaims[index].key;
                                      final claim = filteredClaims[index].value;

                                      return DataRow(
                                        color:
                                            MaterialStateProperty.resolveWith(
                                              (states) => index.isEven
                                                  ? Colors.grey.shade50
                                                  : Colors.white,
                                            ),
                                        cells: [
                                          DataCell(
                                            Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              claim.patientName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(claim.contactNumber)),
                                          DataCell(
                                            Text(
                                              '₹${claim.advance.toStringAsFixed(2)}',
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '₹${claim.totalBill.toStringAsFixed(2)}',
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '₹${claim.pendingAmount.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: claim.pendingAmount > 0
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            StatusChip(status: claim.status),
                                          ),

                                          /// VIEW
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(
                                                Icons.visibility_outlined,
                                              ),
                                              tooltip: 'View Claim Details',
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ClaimDetailScreen(
                                                          index: originalIndex,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                          /// EDIT
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                              ),
                                              tooltip: 'Edit Insurance status',
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        EditClaimScreen(
                                                          claim: claim,
                                                          index: originalIndex,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
