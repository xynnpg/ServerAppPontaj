# Running Pontaj Admin on Android

## Prerequisites

✅ You mentioned you already have:
- Developer mode enabled
- USB debugging enabled

## Step-by-Step Instructions

### 1. Connect Your Android Device

1. Connect your Android phone/tablet to your computer via USB cable
2. On your phone, when prompted, allow USB debugging (check "Always allow from this computer" if you want)
3. Make sure your phone is unlocked

### 2. Verify Device Connection

Open a terminal/command prompt and run:
```bash
flutter devices
```

You should see your Android device listed, something like:
```
sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 13 (API 33)
```

Or if using a physical device:
```
SM G950F (mobile) • R58M123456 • android-arm64 • Android 11 (API 30)
```

### 3. Run the App

Once your device is detected, run:
```bash
flutter run
```

Or if you have multiple devices, specify Android:
```bash
flutter run -d android
```

### 4. What to Expect

- Flutter will build the app (this may take a few minutes the first time)
- The app will be installed on your device
- The app will launch automatically
- You'll see the login screen

### 5. Test the Login

1. Enter your username: `poprazvan09@gmail.com`
2. Enter your password: `1234`
3. Click "Login"
4. You should see the access token displayed (no CORS issues on Android!)

## Troubleshooting

### Device Not Detected?

1. **Check USB connection:**
   - Try a different USB cable
   - Try a different USB port
   - Make sure the cable supports data transfer (not just charging)

2. **Check USB debugging:**
   - Go to Settings → Developer options
   - Make sure "USB debugging" is ON
   - Try toggling it off and on again

3. **Check ADB:**
   ```bash
   adb devices
   ```
   If you see "unauthorized", check your phone for a popup asking to allow USB debugging

4. **Install USB drivers** (if on Windows):
   - Some Android devices need specific USB drivers
   - Check your phone manufacturer's website

### Build Errors?

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check Android SDK:**
   - Make sure you have Android SDK installed
   - Flutter doctor can help: `flutter doctor`

### App Crashes?

1. Check the logs:
   ```bash
   flutter logs
   ```

2. Make sure you have internet permission (already added in AndroidManifest.xml)

## Hot Reload

While the app is running:
- Press `r` in the terminal to hot reload (quick changes)
- Press `R` to hot restart (full restart)
- Press `q` to quit

## Building APK (Optional)

To build an APK file for distribution:
```bash
flutter build apk
```

The APK will be in: `build/app/outputs/flutter-apk/app-release.apk`

## Notes

- **No CORS issues on Android!** The API will work directly without any proxy or CORS configuration
- The app uses the same API endpoint: `https://api.pontaj.binarysquad.club/admin/login`
- All network requests work normally on mobile platforms

