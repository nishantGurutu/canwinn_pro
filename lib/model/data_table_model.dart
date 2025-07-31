class DataTableModel {
  final int srno;
  final String itemName;
  final int isReturnable;
  final int quantity;
  final String remarks;

  DataTableModel({
    required this.srno,
    required this.itemName,
    required this.isReturnable,
    required this.quantity,
    required this.remarks,
  });

  factory DataTableModel.fromJson(Map<String, dynamic> json) {
    return DataTableModel(
      srno: json['srno'] as int,
      itemName: json['item_name'] as String,
      isReturnable: json['is_returnable'] as int,
      quantity: json['quantity'] as int,
      remarks: json['remarks'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'is_returnable': isReturnable,
      'quantity': quantity,
      'remarks': remarks,
    };
  }
}
