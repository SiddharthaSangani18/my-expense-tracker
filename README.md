# 💰 Expense Tracker

A simple and beginner-friendly **Expense Tracker Android application** built using Flutter and Dart. This app helps users record, view, and manage their daily expenses while keeping track of their total spending.

## 📱 Features

- **Add Expenses:** Enter an expense title and amount.
- **View Expenses:** Display all added expenses in a list.
- **Delete Expenses:** Remove expenses when they are no longer needed.
- **Total Calculation:** Automatically calculate the total expenses.
- **Local Data Storage:** Save expense records using SharedPreferences.
- **Persistent Data:** Expenses remain available even after closing and reopening the app.
- **Dark UI:** Clean and minimal dark-themed interface.

## 🛠️ Technologies Used

- **Flutter** – Cross-platform UI framework.
- **Dart** – Programming language.
- **SharedPreferences** – Local key-value storage.
- **Android Studio** – Android emulator and development environment.
- **VS Code** – Code editor.

## 📂 Project Structure

```text
my_expense_tracker/
│
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── expense.dart
│   ├── screens/
│   │   └── home_screen.dart
│   ├── services/
│   │   └── storage_service.dart
│   └── widgets/
│       └── expense_tile.dart
│
├── android/
├── test/
├── pubspec.yaml
└── README.md
```

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android Emulator or Android device

### Installation

1. Clone the repository:

```bash
git clone https://github.com/SiddharthaSangani18/my-expense-tracker.git
```

2. Navigate to the project directory:

```bash
cd my_expense_tracker
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the application:

```bash
flutter run
```

## 🧠 What I Learned

Through this project, I practiced:

- Understanding Flutter widgets and application structure.
- Creating Dart classes and constructors.
- Managing application state.
- Displaying dynamic lists using ListView.
- Handling user input.
- Working with asynchronous programming using async and await.
- Converting Dart objects into JSON and back.
- Storing and retrieving data locally using SharedPreferences.

## 🚀 Future Improvements

