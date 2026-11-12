import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/storage_service.dart';
import '../widgets/expense_tile.dart';

// HomeScreen is a StatefulWidget because its data (the expense list) changes.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();

  // Controllers read the text typed in the two text fields.
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // The form key lets us run the validators of both fields at once.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Expense> _expenses = [];
  bool _isLoading = true;

  // Total of all expenses. Calculated fresh every time the screen rebuilds,
  // so it is always correct after adding or deleting.
  double get _totalAmount {
    double total = 0;
    for (final expense in _expenses) {
      total += expense.amount;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses(); // load saved data when the screen opens
  }

  @override
  void dispose() {
    // Free the memory used by the controllers.
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Loads saved expenses from SharedPreferences.
  Future<void> _loadExpenses() async {
    try {
      final loadedExpenses = await _storageService.loadExpenses();
      if (!mounted) return;
      setState(() {
        _expenses = loadedExpenses;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showMessage('Could not load saved expenses.');
    }
  }

  // Saves the current list to SharedPreferences.
  Future<void> _saveExpenses() async {
    try {
      await _storageService.saveExpenses(_expenses);
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not save expenses.');
    }
  }

  // Called when the "Add Expense" button is pressed.
  Future<void> _addExpense() async {
    // Run the validators. If any field is invalid, stop here.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
    );

    // setState tells Flutter: "data changed, rebuild the screen".
    setState(() {
      _expenses.insert(0, newExpense); // newest expense appears on top
    });

    _titleController.clear();
    _amountController.clear();
    FocusScope.of(context).unfocus(); // close the keyboard

    await _saveExpenses();
  }

  // Called when the delete icon of an expense is pressed.
  Future<void> _deleteExpense(String id) async {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });

    await _saveExpenses();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Shared look for both text fields.
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The form is at the top, so the keyboard can simply cover the list.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('My Expense Tracker'),
        backgroundColor: const Color(0xFF121212),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTotalCard(),
              const SizedBox(height: 12),
              _buildAddForm(),
              const SizedBox(height: 16),
              const Text(
                'Your Expenses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildExpenseList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Expenses',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Text(
              '₹${_totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddForm() {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Title'),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null; // null means "valid"
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: _inputDecoration('Amount (₹)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value.trim());
                  if (amount == null || !amount.isFinite) {
                    return 'Please enter a valid number';
                  }
                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _addExpense,
                icon: const Icon(Icons.add),
                label: const Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_expenses.isEmpty) {
      return const Center(
        child: Text(
          'No expenses yet. Add your first one above!',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    // ListView.builder creates tiles only for the items on screen.
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return ExpenseTile(
          expense: expense,
          onDelete: () => _deleteExpense(expense.id),
        );
      },
    );
  }
}
