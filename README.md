# Flutter Adventure Game

A text-based castle exploration game developed with Flutter and Dart for the Mobile Application Development course as part of the Bachelor of Applied Science in Information Technology – Application Development program at Edmonds College. Players navigate interconnected rooms, collect four items, avoid the dungeon, and return to the Entrance Hall to win.

I designed and implemented this as an individual mobile application course project. The project demonstrates stateful interface development, conditional navigation, game-state management, dynamic controls, and responsive user feedback.

## Gameplay

The player begins in the castle’s Entrance Hall and explores a series of connected rooms. Available movement controls change according to the player’s location.

Four items are hidden throughout the castle:

- Golden Chalice — Banquet Hall
- Blazing Torch — Kitchen
- Throwing Spear — Library
- Ancient Scroll — Armory

The player must collect all four items and return to the Entrance Hall to win. Entering the Dungeon ends the game immediately.

Both outcomes provide an option to reset the game and play again.

## Features

- Seven connected castle locations
- Context-sensitive directional controls
- Four collectible items
- Item collection and progress tracking
- Prevention of duplicate item collection
- Dungeon trap and loss condition
- Inventory-based victory condition
- Separate victory and game-over screens
- Game reset functionality
- Room-specific titles, descriptions, icons, and colors
- Application exit control

## Technical Concepts

- Flutter `StatefulWidget` architecture
- Dart state variables and methods
- Interface updates using `setState()`
- Conditional rendering based on game state
- Room navigation represented through numeric identifiers
- Boolean flags for tracking collected items
- Dynamic generation of movement and item controls
- Reusable Material Design button styles
- Win, loss, and reset state management

## Technologies

- Flutter
- Dart
- Material Design widgets
- Android Studio
- Android Emulator

## Project Structure

The primary game implementation is located in:

```text
lib/main.dart
```

This file contains the room map, navigation logic, collectible-item state, win and loss conditions, and interface rendering.

## Running the Project

### Prerequisites

- Flutter SDK
- Android Studio with the Flutter and Dart plugins, or another Flutter-compatible editor
- Android Emulator or a connected physical device

### Setup

Clone the repository:

```bash
git clone https://github.com/EmmaBlueJeans/flutter-adventure-game.git
cd flutter-adventure-game
```

Install the project dependencies:

```bash
flutter pub get
```

Start an emulator or connect a supported device, then run:

```bash
flutter run
```

## Project Status

The completed game source has been restored to this repository. A browser-based demonstration may be added in the future.
