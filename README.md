# 💬 ChatPro App (In Progress) 🚀

A Flutter application I'm currently developing to practice **clean architecture**, **state management**, and **modern UI design**.  
This project aims to explore reusable widget patterns and real-time data handling with Firebase.

---

## 🧩 Features Implemented So Far
- 👤 Profile screen with real-time user data (Firebase)
- 🎨 Custom `CAppBar` with gradient and shadow effects
- 🧱 Reusable UI components (`CListItem`, `CAvatar`, etc.)
- 🔄 Real-time stream integration for user updates
- 💾 Local data caching using **SharedPreferences**

---

## 🔜 Upcoming Features
- 💬 Chat list and private messaging
- ✏️ Edit profile functionality
- 🔐 Authentication system (Firebase Auth)
- ⚙️ Settings screen (theme, notifications, logout)
- 👥 Group chat support
- 🧭 App-wide theme and navigation polish

---

## 🛠️ Tech Stack
| Layer | Technology |
|-------|-------------|
| **Framework** | Flutter (Dart) |
| **State Management** | Provider + Selector |
| **Backend** | Firebase Firestore |
| **Local Storage** | SharedPreferences |
| **IDE** | Visual Studio Code |

---
### Folder Structure

Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- constants/
|- data/
|- di/
|- ui/
|- utils/
|- widgets/
|- main.dart
|- routes.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- constants - All the application level constants are defined in this directory with-in their respective files. This directory contains the constants for `theme`, `dimentions`, `preferences` and `strings`.
2- data - Contains the data layer of your project, includes directories for local, network and shared pref/cache.
3- di -The `di/` folder manages dependency injection using GetIt, registering all services, and view models for easy access and maintainability.
4- ui — Contains all the ui of your project, contains sub directory for each screen.
5- util — Contains the utilities/common functions of your application.
6- widgets — Contains the common widgets for your applications. For example, Button, TextField etc.
7- routes.dart — This file contains all the routes for your application.
8- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.

## 🚀 Getting Started

To run this project locally:

```bash
git clone https://github.com/your-username/chatpro-flutter.git
cd chatpro-flutter
flutter pub get
flutter run
