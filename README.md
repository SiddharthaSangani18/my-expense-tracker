# My Expense Tracker

A simple Flutter app to add, view and delete expenses, with an automatic total.
Expenses are saved on the device with SharedPreferences.

Built with: Flutter, Dart, Material 3, `setState()` (no state-management packages).

## Features
1. Add expense (title + amount, with validation)
2. View expenses (ListView.builder, card layout)
3. Delete expense
4. Automatic total
5. Local storage (data survives app restarts)

## Project structure
```
lib/
  main.dart                      App entry point + dark theme
  models/expense.dart            Expense class
  screens/home_screen.dart       The only screen
  services/storage_service.dart  Save/load with SharedPreferences
  widgets/expense_tile.dart      One expense card
```

## Setup (VS Code + Android Emulator)

### Prerequisites
- Flutter SDK installed (Dart 3.5 or newer) and `flutter doctor` showing no Android errors
- VS Code with the **Flutter** extension
- An Android emulator created in Android Studio -> Device Manager

### Steps
1. Create a fresh Flutter project (this generates the `android/` folder):
   ```
   flutter create my_expense_tracker --platforms=android
   ```
2. From this ZIP, copy into that new folder, replacing existing files:
   - the `lib/` folder
   - `pubspec.yaml`
   - `analysis_options.yaml`
3. Delete the default test file: `test/widget_test.dart`
4. Open the folder in VS Code (File -> Open Folder).
5. In a terminal inside the project, run:
   ```
   flutter pub get
   flutter analyze
   ```
6. Start your emulator (VS Code bottom-right device selector -> pick the emulator).
7. Press `F5` (or run `flutter run`).

### Test local storage
Add an expense, fully close the app (swipe it away), and open it again. The expense should still be there.
