# ALARP - A Learning Aid In Radiographic Positioning

**ALARP is a Flutter mobile application designed to help Radiologic Technology students learn radiographic positioning concepts and practice essential 2D collimation skills.**

## ✨ Core Features

- **Learn:** Access educational guides on radiographic positioning for various body regions and projections. Includes interactive 3D models for visual reference and understanding spatial relationships.
- **Practice:** Hone your skills primarily with **2D collimation practice**. Adjust collimation borders (rectangle + crosshairs) on anatomical images using intuitive controls. Includes reference information for correct IR size, IR orientation, and patient positioning for the selected projection. Features a **real-time accuracy tracker** providing feedback on collimation precision.
- **Challenge:** Test your knowledge and speed in gamified, timed tasks. Challenges involve selecting the correct positioning, IR size, IR orientation, patient position, and performing accurate collimation under time pressure.
- **Profile:** Track your progress, view statistics, and potentially compete on leaderboards _(future feature)_.
- **Authentication:** Secure user accounts using Supabase (Email/Password, Google) - _(Future Implementation)_.

## 🛠️ Tech Stack

- **Framework:** Flutter (latest stable)
- **Language:** Dart (with null safety)
- **State Management:** Riverpod (`flutter_riverpod`, `hooks_riverpod`)
- **Backend & Database:** Supabase (Auth, PostgreSQL)
- **Routing:** GoRouter
- **UI:** Material Design 3
- **2D Graphics:** Flutter `CustomPaint` for collimation overlay
- **3D Viewer (Learn):** `flutter_3d_controller` (non-interactive)

## 🚀 Getting Started

1.  **Prerequisites:**
    - Flutter SDK installed (check `flutter doctor`)
    - _(Future)_ A Supabase project will be required for backend features (Auth, Database).
2.  **Clone the repository:**
    ```bash
    git clone https://github.com/your_username/alarp.git
    cd alarp
    ```
3.  **_(Future)_ Set up Supabase:**
    - Instructions for setting up the `.env` file with Supabase credentials and running database migrations will be added here once the backend integration is complete.
4.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
5.  **Run the app:**
    ```bash
    flutter run
    ```
