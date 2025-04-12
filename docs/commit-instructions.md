Generate a Git commit message for the ALARP (A Learning Aid In Radiographic Positioning) Flutter project based on the following staged changes.

**Project Context:**
ALARP is a Flutter mobile app using Riverpod for state management and Supabase for the backend. The goal is to help Radiologic Technology students learn positioning and practice collimation. Follow the custom instructions provided previously regarding architecture (MVC-inspired), tech stack, and best practices.

**Desired Format:**
Use the Conventional Commits specification:
type(scope): concise subject line (imperative mood, max 50-72 chars)

[optional body: explain WHAT was changed and WHY. Use bullet points for multiple changes. Keep lines under 72 chars.]

[optional footer: reference issues like Closes #123 or BREAKING CHANGE:]

**Staged Changes Summary / Diff:**
[**IMPORTANT:** Replace this section with either:

1. A concise summary of the changes you made (e.g., "Implemented collimation slider logic in Practice screen", "Fixed user login bug", "Refactored auth repository").
   OR
2. The output of `git diff --staged` (if the changes are complex and you want Copilot to analyze the diff directly - may require more processing by the AI).
   ]

**Example Request:**

Generate a Git commit message for the ALARP (...) project based on the following staged changes.
...
**Staged Changes Summary / Diff:**

- Added horizontal and vertical sliders to `collimation_controls_widget.dart`.
- Updated `CollimationState` to include `width` and `height` properties.
- Connected sliders to update the `CollimationState` via Riverpod provider.
- Ensured `CollimationPainter` uses the new state values to draw the overlay.
  This allows users to adjust the collimation field size in the 2D practice mode.

**Generate the commit message now.**
