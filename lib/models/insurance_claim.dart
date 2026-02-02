class BillItem {
  final String category;
  final String description;
  final DateTime date;
  final double amount;

  BillItem({
    required this.category,
    required this.description,
    required this.date,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'description': description,
    'date': date.toIso8601String(),
    'amount': amount,
  };

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class InsuranceClaim {
  final String id;
  final String patientName;
  final int age;
  final String gender;
  final String contactNumber;
  final String insuranceCompany;
  final DateTime admissionDate;
  final String diagnosis;

  final double advance;
  final double settlement;
  final String status;

  final List<BillItem> bills;

  InsuranceClaim({
    required this.id,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.insuranceCompany,
    required this.admissionDate,
    required this.diagnosis,
    required this.advance,
    required this.settlement,
    required this.status,
    required this.bills,
  });

  double get totalBill =>
      bills.fold<double>(0, (sum, bill) => sum + bill.amount);

  double get pendingAmount {
    final pending = totalBill - (advance + settlement);
    return pending < 0 ? 0 : pending;
  }

  double get refundAmount {
    final extra = (advance + settlement) - totalBill;
    return extra > 0 ? extra : 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientName': patientName,
    'age': age,
    'gender': gender,
    'contactNumber': contactNumber,
    'insuranceCompany': insuranceCompany,
    'admissionDate': admissionDate.toIso8601String(),
    'diagnosis': diagnosis,
    'advance': advance,
    'settlement': settlement,
    'status': status,
    'bills': bills.map((b) => b.toJson()).toList(),
  };

  factory InsuranceClaim.fromJson(Map<String, dynamic> json) {
    return InsuranceClaim(
      id: json['id'],
      patientName: json['patientName'],
      age: json['age'],
      gender: json['gender'],
      contactNumber: json['contactNumber'],
      insuranceCompany: json['insuranceCompany'],
      admissionDate: DateTime.parse(json['admissionDate']),
      diagnosis: json['diagnosis'],
      advance: (json['advance'] as num).toDouble(),
      settlement: (json['settlement'] as num).toDouble(),
      status: json['status'],
      bills: (json['bills'] as List? ?? [])
          .map((e) => BillItem.fromJson(e))
          .toList(),
    );
  }
}
