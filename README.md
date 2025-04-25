# ALARP - A Learning Aid In Radiographic Positioning

**ALARP (A Learning Aid In Radiographic Positioning) is a Flutter app designed to help Radiologic Technology students to master positioning concepts and hone 2D collimation skills through interactive learning and practice.**

## ✨ Core Features

- **Learn:** Access educational guides on radiographic positioning for various body regions and projections. Includes interactive 3D models for visual reference and understanding spatial relationships.
- **Practice:** Hone your skills primarily with **2D collimation practice**. Adjust collimation borders (rectangle + crosshairs) on anatomical images using intuitive controls. Includes reference information for correct IR size, IR orientation, and patient positioning for the selected projection. Features a **real-time accuracy tracker** providing feedback on collimation precision. Tracks practice history.
- **Challenge:** Test your knowledge and speed in gamified, timed tasks. Challenges currently focus on upper extremities and involve selecting the correct positioning, IR size, IR orientation, patient position, and performing accurate collimation under time pressure. Includes daily and all-time leaderboards. Tracks challenge history.
- **Profile:** Track your progress, view statistics (including total app time, challenge history, practice history), and compete on daily/all-time leaderboards.
- **Authentication:** Secure user accounts using Supabase (Email/Password with OTP verification).

## 📸 Screenshots

<!-- Add screenshots here -->

## 🛠️ Tech Stack

- **Framework:** Flutter (latest stable)
- **Language:** Dart (with null safety)
- **State Management:** Riverpod (`flutter_riverpod`, `hooks_riverpod`)
- **Backend & Database:** Supabase (Auth, PostgreSQL, Edge Functions/RPCs)
- **Routing:** GoRouter
- **UI:** Material Design 3
- **2D Graphics:** Flutter `CustomPaint` for collimation overlay
- **3D Viewer:** `flutter_3d_controller`

## 🚀 Getting Started

1.  **Prerequisites:**
    - Flutter SDK installed (check `flutter doctor`)
    - A Supabase project set up.
2.  **Clone the repository:**
    ```bash
    git clone https://github.com/your_username/alarp.git
    cd alarp
    ```
3.  **Set up Supabase:**
    - Create a `.env` file in the root directory.
    - Add your Supabase URL and Anon Key:
      ```dotenv
      SUPABASE_URL=YOUR_SUPABASE_URL
      SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
      ```
    - Run the necessary database migrations/setup scripts located in `supabase/migrations - _ensure this path is correct if it differs_). You might need the Supabase CLI: `supabase db push`.
    - Set up the required RPC functions in your Supabase project (e.g., `increment_streak_if_needed`, `get_daily_leaderboard`, `get_user_daily_rank`, etc.).
4.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
5.  **Run the app:**
    ```bash
    flutter run
    ```
