# 📚 Connect — Peer Study Groups (Flutter App)

**Connect** is a modern, cross-platform Flutter application designed to help university students discover, create, and participate in peer study groups across various academic departments with real-time chat, group management, and analytics.

---

## 🚀 Application Flow & Architecture

```
                       ┌─────────────────────────┐
                       │       App Launch        │
                       └────────────┬────────────┘
                                    │
                                    ▼
                       ┌─────────────────────────┐
                       │      Login Screen       │ ◄────► ┌───────────────────┐
                       │  (Email + Any Password  │        │   Signup Screen   │
                       │     123123 Required)    │        └───────────────────┘
                       └────────────┬────────────┘
                                    │
                                    ▼
                       ┌─────────────────────────┐
                       │    Dashboard Screen     │
                       └────────────┬────────────┘
                                    │
    ┌─────────────────┬─────────────┼─────────────┬─────────────────┐
    │                 │             │             │                 │
    ▼                 ▼             ▼             ▼                 ▼
🔍 Browse        ✏️ Create       📚 My         📊 Stats         ⚙️ Admin
 Groups            Group        Groups       Overview          Panel
    │
    └───────────────► 💬 Open Group Chat Room
```

---

## ✨ Features & Functionality

### 1. 🔐 Authentication Flow (`lib/login_screen.dart` & `lib/signup_screen.dart`)
* **Initial Launch:** The app opens directly on the **Login Screen**.
* **Flexible Email & Password Logic:**
  * **Email:** Accepts **ANY** valid email address.
  * **Password:** Hardcoded to **`123123`** for instant demonstration.
* **Google Sign-In:** One-tap Google authentication option.
* **Forgot Password:** Interactive modal dialog sending password reset email links.
* **Account Registration:** Sign-Up screen collecting Full Name, Email, Password, Student ID, and Department.

---

### 2. 📊 Main Dashboard & Navigation (`lib/main.dart`)
Includes **5 Interactive Category Navigation Tabs**:

1. 🔍 **Browse Groups:**
   * Live search bar to filter study groups by topic, course, or subject.
   * Department filter chips (*Software Engineering, Computer Science, Electrical Engineering, BBA, Data Science, Cybersecurity, Other*).
   * Group Cards displaying session time, location, member capacity chips, WhatsApp contact button, and **Join / Leave / Chat** actions.
2. ✏️ **Create Group:**
   * Interactive creation form to launch a new study group with name, department, session date, join deadline, location, and description.
3. 📚 **My Groups:**
   * Filtered view displaying only groups created by or joined by the logged-in user.
4. 📊 **Overview & Stats:**
   * Visual metrics showing Total Groups, Total Members, Open Spots, and Department Breakdown progress bars.
5. ⚙️ **Admin Panel:**
   * Group creators can manage pending join requests with **Approve** and **Reject** buttons.

---

### 3. 💬 Group Chat Room & Unique Member Colors (`lib/chat.dart`)
Tapping the **Chat** button on any joined group card opens the dedicated `ChatScreen`:

* **Sender Name on Top:** Every message displays the author's name at the top.
* **Unique Color Per Person:**
  * Every member in a group is automatically assigned a distinct, vibrant color (*Blue, Purple, Emerald, Amber, Crimson, Teal, Indigo, Rose*).
  * The member's name, message bubble border, file card, and sidebar avatar match their unique assigned color.
* **Realtime Typing Indicator:**
  * Displays an animated indicator (`Sara Khan is typing...`) when a group member is actively typing.
* **Emoji Picker & Attachments:**
  * Built-in emoji grid picker and PDF file attachment cards.
* **Active Members Sidebar:**
  * Displays all group members with online indicators and unique color avatars.

---

### 🎨 Design System & Performance Highlights

* ⚡ **Lag-Free Theme Switching:** Uses `ValueNotifier<ThemeMode>` and `AnimatedTheme` for smooth 60 FPS transitions between Light Mode (`#F7F5F0`) and Dark Mode (`#0C0A09`).
* 🌙 **Sleek Dark Mode UI:** Dark card borders (`#292524`), clean typography, and zero harsh white outlines.
* 📦 **Modular Architecture:** Clean separation of concerns with `main.dart`, `chat.dart`, `login_screen.dart`, and `signup_screen.dart`.

---

## 🛠️ Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0.0 or higher)
* [Dart SDK](https://dart.dev/get-started/get-dart)
* Android Studio / VS Code

### Running the App
```bash
# Get Flutter dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run on Mobile Emulator or Device
flutter run
```

---

## 🔄 Real-Time Database Sync Roadmap

To connect this application to a real-time cloud database (e.g. Firebase / Supabase) so all user accounts, study groups, and chat messages synchronize live across multiple devices:

1. **Authentication Sync:** Connect `FirebaseAuth` for email/password and Google Sign-In.
2. **Real-time Study Groups:** Connect `Firebase Realtime Database` or `Cloud Firestore` to sync study group creation, member joins, and admin requests instantly across all devices.
3. **Live Group Chat:** Use `StreamBuilder` connected to Firebase chat collections so messages, file attachments, and typing indicators stream live to all group members.
