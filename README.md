# Reels Ulearna

A Flutter application that mimics Instagram Reels, featuring full-screen vertical video playback,
interactive UI, and robust architecture for scalability and maintainability.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x recommended)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio or VS Code (with Flutter and Dart plugins)
- An Android/iOS device or emulator

### Installation

1. **Clone the repository:**

   ```sh
   git clone https://github.com/zeeshan2423/reels-ulearna.git
   cd reels_ulearna
   ```

2. **Install dependencies:**

   ```dart
   flutter pub get
   ```

3. **Run the app:**
    - On Android/iOS device or emulator:
   ```dart
   flutter run
   ```
    - To specify a device:
   ```dart
   flutter devices
   flutter run -d <device_id>
   ```

## 🏗️ Project Structure & Architecture

This project follows **Clean Architecture** for clear separation of concerns:

```sh
lib/
features/
 reels/
   data/         # Data sources, models, repositories
   domain/       # Entities, repository interfaces, use cases
   presentation/ # UI widgets, BLoC, screens
core/             # Common utilities, error handling, themes
```

- Domain Layer: Business logic, entities, repository interfaces
- Data Layer: API calls, local storage, data models
- Presentation Layer: UI components, BLoC state management

## 🔄 State Management

Uses the **BLoC Pattern** for predictable state management:

- **Events:** e.g., `LoadReelsEvent`, `RefreshReelsEvent`
- **States:** e.g., `Loading`, `Loaded`, `Error`
- **Business Logic:** Separated from UI for testability

## 🌐 API Integration & Error Handling

- HTTP client with timeout and error handling
- Graceful fallback to cached data when offline or on error

## 📱 Features

- **Reels UI:** Full-screen vertical video playback, smooth transitions
- **Interactive Actions:** Like, comment, share buttons
- **User Overlay:** User info displayed over video
- **Pagination:** Infinite scroll with lazy loading
- **Caching:** Local storage for offline support
- **Performance:** Efficient list rendering, memory management

## 📝 Notes for Developers

- **Dependency Injection:** Uses GetIt for service location and easy testing
- **Error Handling:** Comprehensive error states and user feedback
- **Extensibility:** Add new features by extending domain/data/- presentation layers
- **Offline Support:** Cached data ensures app works without internet

## 💡 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

## 🙋 FAQ

**Q:** How do I add a new API endpoint?  
**A:** Add the endpoint in the data layer, update the repository, and create corresponding use cases
in the domain layer.

**Q:** How do I add a new UI feature?  
**A:** Add new widgets in the presentation layer and connect them to the BLoC for state management.

## 📫 Contact

For questions or support, open an issue or contact zeeshan2423@gmail.com.
