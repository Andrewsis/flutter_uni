# Student Portal - Flutter Mobile Application

A comprehensive mobile application built with **Flutter** and **Dart** designed to help students manage their academic and personal lives. This project demonstrates the implementation of a multi-screen architecture, persistent local storage, and interactive UI components.

---

## 🎯 Project Goal
The primary objective of this project was to master the Flutter development lifecycle, including widget tree management, navigation stacks, and adaptive interface design according to **Material Design** principles.

## 🚀 Key Features

* **Main Dashboard:** A centralized navigation hub using a `GridView` to access all app modules, including Deadlines, Profile, and Health.
* **Tasks & Deadlines:** A system for managing academic assignments with data persistence using `SharedPreferences` and `JSON` encoding.
* **Student Profile:** A customizable profile section where users can edit their name, group, and email, as well as upload a profile picture using the `image_picker`.
* **Health & Focus Tracker:** A dedicated module for wellness that includes a checklist-based habit tracker and a list for managing health tips.
* **Data Persistence:** Uses `SharedPreferences` to ensure user data, such as tasks, habits, and profile information, is saved locally on the device.

## 🛠️ Technologies Used

* **Framework:** Flutter.
* **Language:** Dart.
* **Storage:** `shared_preferences` for persistent local data.
* **Media & Files:** `image_picker`, `path_provider`, and `path` for profile photo management.
* **Data Handling:** `dart:convert` for JSON serialization of tasks and habits.

## 📱 Project Structure

The application is organized into a clean, screen-based architecture:
* `home_screen.dart`: The entry point and main menu with navigation routes.
* `tasks_screen.dart`: Logic for adding, deleting, and storing student tasks.
* `profile_screen.dart`: User information management and image handling.
* `health_screen.dart`: Wellness tips and an interactive habit tracker.

## ⚙️ Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/andrewsis/student-portal-flutter.git](https://github.com/andrewsis/student-portal-flutter.git)
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```

---
*Developed as a practical university project to demonstrate proficiency in Flutter mobile development.*