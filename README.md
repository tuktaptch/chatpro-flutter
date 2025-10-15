# 💬 ChatPro App (In Progress) 🚀

A Flutter application I'm currently developing to practice **clean architecture**, **state management**, and **modern UI design**.  
This project aims to explore reusable widget patterns and real-time data handling with Firebase.
<img width="1920" height="1080" alt="1" src="https://github.com/user-attachments/assets/f3a8f306-e9c6-4d2c-ac45-0d997cbc0437" />
<img width="1920" height="1080" alt="2" src="https://github.com/user-attachments/assets/65e6491d-db90-4035-867d-3d2302a5a285" />
<img width="1920" height="1080" alt="3" src="https://github.com/user-attachments/assets/bab5e316-82a6-4d25-818b-a5be15d8aca2" />
<img width="1920" height="1080" alt="4" src="https://github.com/user-attachments/assets/d78f3ecf-be5d-4dd9-bf94-22b30fe0d886" />
<img width="1920" height="1080" alt="5" src="https://github.com/user-attachments/assets/15716d6c-2027-4b52-aee8-a1469cc4cd99" />
<img width="1920" height="1080" alt="6" src="https://github.com/user-attachments/assets/e4b142dd-a74e-48a8-84f4-4ff6555a2f4e" />
<img width="1920" height="1080" alt="7" src="https://github.com/user-attachments/assets/08e13095-0fed-459f-a078-d54e1d9f3079" />
<img width="1920" height="1080" alt="8" src="https://github.com/user-attachments/assets/0738f45b-d3c8-4463-9165-d4bd0d6dfcfb" />
<img width="1920" height="1080" alt="9" src="https://github.com/user-attachments/assets/074de34e-63a8-41c9-922a-21e33354cdb8" />
<img width="1920" height="1080" alt="10" src="https://github.com/user-attachments/assets/084ab5f3-23d3-4d40-95d5-999ac540dc00" />


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
