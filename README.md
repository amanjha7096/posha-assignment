# 🍽️ Recipe App (Flutter)

A modern **Flutter Recipe Application** built using **Clean Architecture**, **BLoC state management
**, and **GoRouter navigation**.  
The app allows users to browse, search, filter, and manage favorite recipes with a smooth and
responsive UI.

---

## 📥 Download APK

You can directly download and install the app using the APK file:

👉 **[Download APK](apk/app-release.apk)**

---

## 🚀 Features

- 📋 Browse recipes in Grid / List view
- 🔍 Search recipes by name
- 🎯 Filter by category & area
- ❤️ Favorite recipes support
- 🔄 Toggle view modes
- ⚡ Shimmer loading UI
- ❌ Error handling with retry
- 🧪 Comprehensive widget tests
- 🌍 Localization (l10n) support

---

## 🛠️ Tech Stack

| Category             | Technology            |
|----------------------|-----------------------|
| Framework            | Flutter               |
| State Management     | BLoC                  |
| Navigation           | GoRouter              |
| Architecture         | Clean Architecture    |
| Networking           | REST API              |
| Dependency Injection | Custom DI             |
| Testing              | Flutter Test, Mockito |
| Localization         | Flutter l10n          |

---

## 📁 Project Structure

```bash
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── enums/
│   ├── network/
│   ├── router/
│   ├── theme/
│   └── utils/
│
├── features/
│   └── recipes/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── local/
│       │   │   └── remote/
│       │   ├── models/
│       │   ├── repositories/
│       │   └── services/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       │
│       └── presentation/
│           ├── bloc/
│           │   ├── favorites/
│           │   ├── recipe_detail/
│           │   └── recipe_list/
│           ├── pages/
│           └── widgets/
│
└── l10n/

```

## 🏗️ Architecture Overview

This project follows **Clean Architecture**, separating concerns into three main layers:

### 🔹 Presentation Layer

Handles everything related to UI and user interaction.

Includes:

- Pages (Screens)
- Widgets (Reusable UI components)
- BLoC (State management)

Responsibilities:

- Displaying data
- Handling user input
- Triggering BLoC events

---

### 🔹 Domain Layer

Contains the **business logic** of the application.

Includes:

- Entities (Core models)
- Use Cases (Application-specific actions)
- Repository interfaces

Responsibilities:

- Defining app rules
- Processing data
- Staying independent of UI and frameworks

---

### 🔹 Data Layer

Manages all **data sources**.

Includes:

- Remote APIs
- Local storage
- Models & Mappers
- Repository implementations

Responsibilities:

- Fetching and saving data
- Converting API models to domain entities

---

## 🧪 Testing

The project includes **widget tests** for:

- UI rendering
- Bloc event dispatching
- Navigation
- Error & loading states
- View mode toggling

Run tests using:

```bash
flutter test
```

## ▶️ How to Run the Project

1. **Clone the repository**

```bash
git clone https://github.com/your-username/recipe-app.git
```

2.**Install Dependency**

```bash
flutter pub get
```

3.**Run Flutter app**

```bash
flutter run
```

