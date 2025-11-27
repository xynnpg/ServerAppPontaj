# Install Java 11 for Flutter Android Development

## Quick Installation (Windows)

### Option 1: Using Chocolatey (Recommended)

If you have Chocolatey installed:
```bash
choco install openjdk11
```

If you don't have Chocolatey, install it first:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Then:
```bash
choco install openjdk11
```

### Option 2: Manual Installation

1. Go to: https://adoptium.net/temurin/releases/
2. Select:
   - Version: **11 (LTS)**
   - Operating System: **Windows**
   - Architecture: **x64**
3. Download the installer (.msi file)
4. Run the installer and follow the prompts
5. Make sure to check "Set JAVA_HOME variable" during installation

### Option 3: Using Scoop

If you have Scoop:
```bash
scoop install temurin11-jdk
```

## After Installation

### 1. Verify Installation

Open a **NEW** command prompt (important - restart it to get new PATH):
```bash
java -version
```

You should see:
```
openjdk version "11.0.x"
```

### 2. Set JAVA_HOME (if not set automatically)

1. Find where Java 11 was installed (usually `C:\Program Files\Eclipse Adoptium\jdk-11.x.x-hotspot` or `C:\Program Files\Java\jdk-11.x.x`)
2. Right-click "This PC" → Properties → Advanced system settings
3. Click "Environment Variables"
4. Under "System variables", click "New"
5. Variable name: `JAVA_HOME`
6. Variable value: Path to Java 11 (e.g., `C:\Program Files\Eclipse Adoptium\jdk-11.0.21.9-hotspot`)
7. Click OK
8. Find "Path" in System variables, click "Edit"
9. Add: `%JAVA_HOME%\bin`
10. Click OK on all dialogs

### 3. Restart Your Terminal

Close and reopen your command prompt/terminal.

### 4. Verify Again

```bash
java -version
javac -version
```

Both should show Java 11.

### 5. Try Flutter Build Again

```bash
cd C:\Users\xynnp\Documents\Projects\PontajAdmin\pontaj_admin
flutter clean
flutter pub get
flutter run
```

## If You Have Multiple Java Versions

You can set JAVA_HOME to point to Java 11 specifically, and Gradle will use that.

## Quick Test

After installing Java 11, run:
```bash
java -version
```

If it still shows Java 8, you may need to:
1. Restart your computer, OR
2. Manually set JAVA_HOME as described above

