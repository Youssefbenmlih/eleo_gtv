class Transaction {
  late double amount;
  late int id;
  late String title;
  late DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.title,
    required this.date,
  });
}
