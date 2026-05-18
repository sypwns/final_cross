# Smart Study Planner App

A Flutter final project designed for cross-platform mobile development. The app helps students organize tasks, deadlines, notes, progress, and productivity in one clean interface.

## Team
Maximum team size: 2 students. Both members must participate in programming and defense.

## Aim
To develop a modern cross-platform Flutter mobile application that helps students plan study tasks, track deadlines, save notes, and monitor productivity progress.

## Main Features
- Dashboard with progress overview
- Add, complete, and delete study tasks
- Priority levels: Low, Medium, High
- Deadline calendar overview
- Notes page
- Statistics chart
- Dark/light mode
- Local SQLite database
- Notification after saving a task
- Responsive Material 3 UI
- MVVM + Provider architecture

## Architecture
The project follows MVVM architecture:

- `models/` — data models
- `views/` — UI screens
- `viewmodels/` — state management and business logic
- `services/` — SQLite database and notifications
- `widgets/` — reusable UI components
- `utils/` — theme and constants

## Technologies
- Flutter
- Dart
- Provider
- SQLite / sqflite
- SharedPreferences
- flutter_local_notifications
- fl_chart
- Material Design 3

## Existing Technologies Comparison
| App | Strength | Weakness |
|---|---|---|
| Google Calendar | Strong scheduling | Weak study task tracking |
| Todoist | Powerful task manager | Many advanced tools are paid |
| Notion | Flexible notes and planning | Can be complex for simple student use |
| Smart Study Planner | Combines tasks, notes, statistics, deadlines | Educational prototype |

## Responsibilities
### Student 1: UI and Frontend
- Dashboard UI
- Task screen UI
- Calendar UI
- Notes UI
- Profile UI
- Theme, colors, animations, responsiveness
- Presentation screenshots

### Student 2: Logic and Backend
- Models
- Provider ViewModel
- SQLite database
- Add/delete/complete task logic
- Notes saving logic
- Notifications
- Testing and debugging
- README documentation

## Setup Instructions
1. Install Flutter SDK.
2. Open this folder in VS Code or Android Studio.
3. Run:
```bash
flutter pub get
flutter run
```

## Testing
Run:
```bash
flutter test
```

## Defense Notes
During defense, explain:
- Why Flutter was selected
- MVVM + Provider architecture
- SQLite offline storage
- UI/UX decisions
- Main app functions
- Testing and debugging
- Future improvements

## Future Improvements
- User authentication
- Cloud synchronization
- Advanced calendar view
- Push notification scheduling
- Export study progress as PDF
