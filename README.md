# Pontaj Admin

A Flutter web application for managing the Pontaj attendance system with an elegant, modern interface.

## Features

- **User Authentication**: Secure login system with session management
- **Dashboard**: Visual analytics with charts showing attendance data
- **Admin Panel**: Manage users, attendance records, and system settings
- **Responsive Design**: Works seamlessly on desktop and mobile browsers
- **Modern UI**: Premium design with smooth animations and transitions

## Development

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart SDK

### Running Locally

```bash
# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Build for web
flutter build web --release
```

## Docker Deployment

This application can be easily deployed using Docker and Docker Compose.

### Quick Start

```bash
# Build and start the application
docker-compose up -d

# View at http://localhost:8080
```

### Full Deployment Guide

For complete deployment instructions, configuration options, and troubleshooting, see [DEPLOYMENT.md](DEPLOYMENT.md).

## Project Structure

```
lib/
├── main.dart              # Application entry point
├── models/                # Data models
├── screens/               # UI screens
│   ├── login_screen.dart
│   └── admin_dashboard.dart
├── services/              # Business logic and API services
└── theme/                 # App theming and styles
```

## Dependencies

- `http` - HTTP client for API requests
- `shared_preferences` - Local storage for session management
- `fl_chart` - Beautiful charts and graphs
- `intl` - Internationalization support

## License

See [LICENSE](LICENSE) file for details.
