class AssetsSubmitModel {
  final String name;
  final int qty;
  final List<String> serialNo;

  AssetsSubmitModel({
    required this.name,
    required this.qty,
    required this.serialNo,
  });

  factory AssetsSubmitModel.fromMap(Map<String, dynamic> map) {
    return AssetsSubmitModel(
      name: map['name'],
      qty: map['qty'],
      serialNo: List<String>.from(map['serial_no'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qty': qty,
      'serial_no': serialNo,
    };
  }
}
