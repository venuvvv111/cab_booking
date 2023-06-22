// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) => WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  String status;
  String message;
  int walletBalance;
  List<Transaction> transactions;

  WalletModel({
    required this.status,
    required this.message,
    required this.walletBalance,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    status: json["status"],
    message: json["message"],
    walletBalance: json["wallet_balance"],
    transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "wallet_balance": walletBalance,
    "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
  };
}

class Transaction {
  String id;
  String uniqueId;
  String type;
  String typeId;
  String amount;
  String transactionId;
  String transactionType;
  String mode;
  String createdAt;
  DateTime updatedAt;

  Transaction({
    required this.id,
    required this.uniqueId,
    required this.type,
    required this.typeId,
    required this.amount,
    required this.transactionId,
    required this.transactionType,
    required this.mode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    uniqueId: json["unique_id"]!,
    type: json["type"]!,
    typeId: json["type_id"],
    amount: json["amount"],
    transactionId: json["transaction_id"],
    transactionType: json["transaction_type"],
    mode: json["mode"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "type": type,
    "type_id": typeId,
    "amount": amount,
    "transaction_id": transactionId,
    "transaction_type": transactionType,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "mode" : mode,
  };
}
