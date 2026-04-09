# Dua - Smart Medication Assistant 💊

**Dua** is a professional, elegantly designed Flutter application that empowers users to search for medications, check prices, and find alternative treatments with ease. Built with a focus on premium UI/UX (the **Medical Slate** design system), it provides a seamless and trusted experience for managing healthcare information.

---

## ✨ Key Features

### 🔍 Smart Medication Search
Quickly find medications by name or active ingredient. The search system uses a remote data source to ensure up-to-date information on availability and pricing.

### 💡 Alternative Discovery
Stop wasting time searching for alternatives. Dua automatically suggests equivalent medications with the same active ingredients, helping users find cost-effective options.

### ❤️ Favorites
Save your most important medications for viewing. Dua uses **Hive** for high-performance local persistence, ensuring your data is always accessible.

### 🛡️ Access Control & Security
Integrated security features including a sleek splash screen and access verification to ensure a professional and safe user experience.

### 🌍 Full Arabic Support
Tailored specifically for Arabic-speaking users with professional **Cairo** typography and Right-to-Left (RTL) layout optimization.

---

## 🎨 Design Philosophy: Medical Slate

Dua is built on the **Medical Slate** design language, characterized by:
- **Calming Palette**: Deep Indigo (`#1E40AF`) and Medical Teal (`#0D9488`) on a soft Slate background.
- **Premium Components**: Custom-built cards, shimmers, and micro-animations for a high-end feel.
- **Micro-Animations**: Uses `animate_do` for subtle, professional transitions that enhance user trust.

---

## 🏗️ Architecture: Clean Architecture

The project follows strict **Clean Architecture** principles to ensure scalability and maintainability:

### Directory Structure
```text
lib/
├── core/               # Shared logic, themes, and common widgets
│   ├── di/             # Dependency injection (GetIt)
│   ├── network/        # API clients and network logic
│   ├── theme/          # Medical Slate theme definitions
│   ├── widgets/        # Reusable premium UI components
│   └── error/          # Failure and exception handling
└── features/           # Modular business logic (Clean Architecture)
    ├── access_control/ # Security and initialization
    ├── drug_search/    # Search and results logic
    ├── drug_details/   # Detailed info and alternatives
    ├── favorites/      # Offline data management
    └── app_info/       # Application information screen
```

### Data → Domain → Presentation
- **Data Layer**: Repositories, data sources, and models (Hive/API).
- **Domain Layer**: Pure business logic (Entities and Use Cases).
- **Presentation Layer**: BLoC/Cubit for state management and Flutter UI.

---

## 🛠️ Technical Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.7.2)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Local Database**: [hive](https://pub.dev/packages/hive) for 100% offline persistence support for favorites.
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Functional Programming**: [dartz](https://pub.dev/packages/dartz) for error handling.
- **Typography**: [google_fonts](https://pub.dev/packages/google_fonts) (Cairo).
- **Animations**: [animate_do](https://pub.dev/packages/animate_do).

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- An Android/iOS device or emulator

### Installation
1. Clone the repository.
2. Run `flutter pub get`.
3. Run `flutter run`.

---

**Created by [Moelshafey](https://github.com/MOELSHAFEY) © 2026**
