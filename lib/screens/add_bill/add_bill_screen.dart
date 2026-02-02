import 'package:flutter/material.dart';
import 'package:insurance_claim_management_system/models/insurance_claim.dart';

class AddBillScreen extends StatefulWidget {
  final BillItem? bill;

  const AddBillScreen({super.key, this.bill});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController descCtrl;
  late TextEditingController amountCtrl;
  final billDateCtrl = TextEditingController();

  late String category;
  DateTime? billDate;

  @override
  void initState() {
    super.initState();

    category = widget.bill?.category ?? 'Room';
    billDate = widget.bill?.date;

    descCtrl = TextEditingController(text: widget.bill?.description ?? '');
    amountCtrl = TextEditingController(
      text: widget.bill?.amount.toString() ?? '',
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: billDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        billDate = picked;
        billDateCtrl.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bill == null ? 'Add Bill' : 'Edit Bill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: category,
                decoration: const InputDecoration(labelText: 'Bill Category'),
                items:
                    const ['Room', 'Medicine', 'Lab', 'Surgery', 'Consultation']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => category = val!,
              ),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: billDateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Bill Date',
                      hintText: 'Select date',
                    ),
                    validator: (_) => billDate == null ? 'Required' : null,
                  ),
                ),
              ),
              TextFormField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Amount is required';
                  }

                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Enter valid numeric amount';
                  }

                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(
                        context,
                        BillItem(
                          category: category,
                          description: descCtrl.text.trim(),
                          date: billDate!,
                          amount: double.tryParse(amountCtrl.text) ?? 0,
                        ),
                      );
                    }
                  },
                  child: Text(widget.bill == null ? 'Add Bill' : 'Update Bill'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
