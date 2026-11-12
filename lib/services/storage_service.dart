import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';

// This class only deals with saving and loading expenses.
class StorageService {
  // The "name" under which our data is stored in SharedPreferences.
  static const String _storageKey = 'expenses';

  // Saves the whole list of expenses as one JSON string.
  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();

    // Expense objects -> Maps -> one JSON string
    final List<Map<String, dynamic>> expenseMaps =
        expenses.map((expense) => expense.toMap()).toList();
    final String jsonString = jsonEncode(expenseMaps);

    await prefs.setString(_storageKey, jsonString);
  }

  // Loads the saved expenses. Returns an empty list if nothing is saved yet.
  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      return [];
    }

    // JSON string -> list of Maps -> Expense objects
    final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;
    return decodedList
        .map((item) => Expense.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
