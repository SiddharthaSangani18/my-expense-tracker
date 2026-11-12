// The Expense class describes ONE expense.
// Each expense has an id, a title and an amount.
class Expense {
  final String id;
  final String title;
  final double amount;

  // Constructor: used to create an Expense object.
  // Example: Expense(id: '1', title: 'Tea', amount: 20)
  Expense({
    required this.id,
    required this.title,
    required this.amount,
  });

  // Converts an Expense object into a Map so it can be saved as JSON text.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
    };
  }

  // Creates an Expense object from a Map (used when loading saved data).
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      // JSON may give an int (like 50) or a double (like 50.5),
      // so we read it as num and convert it to double.
      amount: (map['amount'] as num).toDouble(),
    );
  }
}
