# 🐦 NIA HRMS - Shorebird Complete Guide

> Complete playbook: Live on Play Store / App Store + Testing APK + OTA (Over-The-Air) updates
> This guide covers **Android** and **iOS** end to end.

---

## Table of Contents

1. [What is Shorebird?](#1-what-is-shorebird)
2. [Prerequisites](#2-prerequisites)
3. [Project Setup (Already Done)](#3-project-setup-already-done)
4. [Part A - Android](#part-a--android)
   - [A1. Build APK for Testing](#a1-build-apk-for-testing)
   - [A2. Release Signing (Keystore)](#a2-release-signing-keystore)
   - [A3. Create Shorebird Release](#a3-create-shorebird-release)
   - [A4. Upload to Play Store](#a4-upload-to-play-store)
   - [A5. Push Patch (OTA Update)](#a5-push-patch-ota-update)
5. [Part B - iOS](#part-b--ios)
   - [B1. iOS Prerequisites](#b1-ios-prerequisites)
   - [B2. Build iOS for Testing](#b2-build-ios-for-testing)
   - [B3. Release Signing (Certificates)](#b3-release-signing-certificates)
   - [B4. Create Shorebird iOS Release](#b4-create-shorebird-ios-release)
   - [B5. Upload to App Store / TestFlight](#b5-upload-to-app-store--testflight)
   - [B6. Push iOS Patch](#b6-push-ios-patch)
6. [What CAN and CANNOT be OTA Updated](#6-what-can-and-cannot-be-ota-updated)
7. [Versioning Rules](#7-versioning-rules)
8. [Common Issues & Fixes](#8-common-issues--fixes)
9. [Best Practices](#9-best-practices)
10. [Command Cheat Sheet](#10-command-cheat-sheet)

---

## 1. What is Shorebird?

Shorebird = **Code push for Flutter**. It lets you ship bug fixes and UI changes
directly to users **without** going through Play Store / App Store review again.

How it works:

```
You write code  →  shorebird patch  →  Shorebird CDN  →  Users' apps update on next launch
```

- The app is built with the **Shorebird engine** (a custom Flutter engine).
- Every release is registered with the Shorebird console.
- A patch is a **Dart-code diff** on top of the last release.

---

## 2. Prerequisites

| Item | Android | iOS |
|---|---|---|
| Shorebird CLI | `shorebird --version` (installed: 1.6.120) | same |
| Logged in | `shorebird login` (done) | same account |
| Keystore | `keytool` (comes with JDK 17) | Apple Developer certs |
| Store account | Google Play Console | Apple Developer Program ($99/yr) |
| Mac | Not required | ✅ Required |

---

## 3. Project Setup (Already Done)

```bash
# ---- DONE ----
shorebird init --display-name="NIA HRMS"
```

This created:

```
shorebird.yaml          # <-- app_id, checked into git, NOT sensitive
pubspec.yaml            # <-- already listed shorebird.yaml as asset
```

Current `shorebird.yaml` (do not edit the app_id):

```yaml
# This file configures the Shorebird updater used by your app.
# Learn more at https://docs.shorebird.dev
# Not sensitive; safe to commit to version control.
app_id: 6c8efc69-8465-4760-8211-7e63d87d1d81

# Uncomment to disable auto background updates:
# auto_update: false
```

Verify everything is healthy anytime with:

```bash
shorebird doctor
```

---

# Part A - Android

## A1. Build APK for Testing

Use this to test your work WITHOUT Shorebird (fastest, normal Flutter build):

```bash
# Debug APK (fastest, contains debug mode)
flutter build apk --debug

# Release APK (optimized, minified), signed with DEBUG key (current config)
flutter build apk --release

# Split APK per CPU arch (smaller installs)
flutter build apk --release --split-per-abi

# Android App Bundle (required by Play Store eventually)
flutter build appbundle --release
```

Output locations:

```
build/app/outputs/flutter-apk/app-debug.apk
build/app/outputs/flutter-apk/app-release.apk
build/app/outputs/bundle/release/app-release.aab
```

Install on a connected device / emulator:

```bash
flutter install -d <device-id>          # installs last debug build
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## A2. Release Signing (Keystore)

> ⚠️ **IMPORTANT**: Your project currently signs release builds with the **debug**
> keystore. **Play Store will REJECT** updates signed differently. Do this first.

### Step 1 - Generate a release keystore (ONE TIME)

```bash
# One file for your whole career of this app. KEEP IT SAFE. Never share it.
keytool -genkey -v -keystore C:\Users\nisha\keys\nia_hrms.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias nia_hrms
```

You'll be asked for passwords + name/org. Store the passwords in a password
manager.

### Step 2 - Create `key.properties` (git-ignored)

File: `android/key.properties`  (Do NOT commit this!)

```properties
# Keystore credentials - SECRET. Referenced from build.gradle.kts
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=nia_hrms
storeFile=C:/Users/nisha/keys/nia_hrms.jks
```

### Step 3 - Wire it into `android/app/build.gradle.kts`

Replace the `release` block (lines 34-40):

```kotlin
// Load keystore props from key.properties (excluded from git)
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"] as String??.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
    buildTypes {
        release {
            // Sign release with the real keystore, not debug!
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

### Step 4 - Update `.gitignore`

Add (root `.gitignore`):

```gitignore
# Keystore secrets - never commit
android/key.properties
*.jks
*.keystore
```

---

## A3. Create Shorebird Release (Android)

> Use Shorebird release ONLY when you want users to be able to receive OTA patches.

```bash
# Release the current published version (from pubspec.yaml, e.g. 1.0.0+1)
shorebird release android

# Release with version name and build number explicitly
shorebird release android --release-version=1.0.0+1

# Upload artifacts after building
shorebird release android --artifact=bundle
```

Options:

```bash
--artifact=apk        # only APK
--artifact=aab        # only App Bundle (Play Store)
--artifact=bundle     # ALL artifacts (APK + AAB)
--release-version    # Matches versionName+buildNumber
--flutter-version    # pin a Flutter/engine version
```

What happens:

1. Builds with the Shorebird (code-push capable) Flutter engine
2. Creates a **release** in the Shorebird console
3. Saves output to `build/app/outputs/...`

You will be asked interactively: **"How to distribute this release?"**
> ✅ If you already built it → choose `None` and grab the files from `build/`
> (recommended when you need to upload the AAB yourself to Play Console)

### Check it on the console

```bash
shorebird apps                          # list your apps
# or open https://console.shorebird.dev and find "NIA HRMS"
```

---

## A4. Upload to Play Store

1. Go to https://play.google.com/console → select app → **Testing → Internal testing**
2. Click **Create new release**
3. Upload the **AAB**: `build/app/outputs/bundle/release/app-release.aab`
4. Fill release notes, Set "Rollout 100%", **Start rollout to Internal testing**
5. Add testers (their Play Store emails) → testers accept invite & install from Play Store
6. Once validated → **Promote to Closed/Open/Beta**, then **Production** track

> ⚠️ Install the **release (AAB) version** from Play, NOT a debug APK, when
> testing patches. Patches only apply to **Shorebird-built releases**.

---

## A5. Push Patch (OTA Update)

After you fix a bug / change UI / update logic in Dart code:

```bash
shorebird patch android
```

That's it! Users who installed the Shorebird release get the update
**automatically on next app launch** (default `auto_update: true`).

```bash
# Patch an older release version
shorebird patch android --release-version=1.0.0+1

# Preview a patch before shipping to everyone
shorebird preview
```

> `shorebird preview` installs the app on a connected device with a
> patch-preview link so you can test before rollout.

---

# Part B - iOS

## B1. iOS Prerequisites

iOS requires **a Mac with Xcode** (Shorebird iOS builds run on macOS).

| Missing item in this project | How to fix |
|---|---|
| `ios/Podfile` | `cd ios && pod init && pod install` |
| `ios/Runner/GoogleService-Info.plist` (Firebase) | download from Firebase console → add to Runner |
| Team/signing | set in `ios/Runner.xcodeproj` (Signing & Capabilities) |

### Support tools you must have

```bash
shorebird doctor                       # check overall readiness
xcodebuild -version                    # Xcode present (Mac only)
```

---

## B2. Build iOS for Testing

```bash
# Build for a simulator (no signing)
flutter build ios --simulator

# Run on a physical device with dev cert
flutter build ios --debug --no-codesign
flutter run

# Release build (need signing identity + provisioning profile)
flutter build ios --release
```

---

## B3. Release Signing (Certificates)

Do this through Xcode:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** target → **Signing & Capabilities**
3. Check **Automatically manage signing**
4. Select your **Team** (Apple Developer account)
5. Confirm `Bundle Identifier` (e.g. `com.app.nia_hrms`)

Verify:

```bash
flutter build ios --release --no-codesign   # if this builds, signing config is fine
```

> You also need **App Transport Security** if the API is HTTP (uses
> `usesCleartextTraffic` on Android) → add to `ios/Runner/Info.plist`:
> ```xml
> <key>NSAppTransportSecurity</key>
> <dict>
>   <key>NSAllowsArbitraryLoads</key>
>   <true/>
> </dict>
> ```

---

## B4. Create Shorebird iOS Release

```bash
shorebird release ios

# Explicit version
shorebird release ios --release-version=1.0.0+1

# Create App Store archive too (-A creates it for upload)
shorebird release ios -A
```

Output (Xcode archive):

```
build/ios/ipa/*.ipa
```

Since iOS 17.2+ Flutter/Shorebird supports OTA on iOS. Requirement: the release
must be uploaded to Shorebird servers (that's what the command does).

---

## B5. Upload to App Store / TestFlight

```bash
# The -A flag already created the archive. Now upload it:
xcodebuild -exportArchive \
  -archivePath build/ios/archive/Runner.xcarchive \
  -exportOptionsPlist exportOptions.plist \
  -exportPath build/ios/ipa

# ...or use Transporter / Xcode Organizer to upload the .ipa
```

Then in App Store Connect:

1. https://appstoreconnect.apple.com → select the app (create if needed)
2. **TestFlight** → upload the build → add testers
3. Approve beta → testers install via TestFlight
4. Release → **App Store** → submit for review

> ⚠️ The TestFlight/App Store build MUST be the one produced by
> `shorebird release ios` so patches can apply.

---

## B6. Push iOS Patch

```bash
shorebird patch ios

# Target a specific release
shorebird patch ios --release-version=1.0.0+1
```

> Patches on iOS behave the same as Android: Dart-only changes, no review needed.

---

## 6. What CAN and CANNOT be OTA Updated

| Change | OTA? |
|---|---|
| Dart code, UI, screens, controllers, models | ✅ Yes |
| Bug fixes in pure Dart logic | ✅ Yes |
| Adding a **new Dart package** that has NO native code | ⚠️ Patch works (Dart-only) |
| Adding a plugin with native code (new pub package with android/ios dirs) | ❌ NO → new release |
| Assets (images/fonts) | ⚠️ Only if packaged in the release build |
| AndroidManifest / build.gradle changes | ❌ NO |
| iOS Info.plist / Podfile changes | ❌ NO |
| Firebase config files, permissions | ❌ NO |
| Upgrading Flutter SDK | ❌ NO (new release) |

**Rule of thumb:** If a native (`android/`, `ios/`, `macos/...`) file changes,
make a **new release**. Otherwise use a **patch**.

---

## 7. Versioning Rules

- Version format is `versionName+buildNumber` (e.g. `1.0.0+1`) from `pubspec.yaml`.
- **Shorebird releases must have a version that has NOT been used before.**
- Increase the build number for every Play Store / App Store submission.
- Patches are attached to a specific version. You can patch the same version
  any number of times.

```yaml
# pubspec.yaml - bump build number (+N) per store submission
version: 1.0.0+1
```

```bash
shorebird release android --release-version=1.0.0+1
shorebird patch android   --release-version=1.0.0+1   # patch that release
```

---

## 8. Common Issues & Fixes

| Issue | Fix |
|---|---|
| `You must be logged in` | `shorebird login` |
| `Storage permission` errors in app | Use SAF (flutter_file_dialog) instead of raw `/storage/emulated/0/Download` writes |
| Release uses debug key | Configure `key.properties` + signingConfigs (Section A2) |
| Play Store rejects duplicate AAB | Bump version in `pubspec.yaml` |
| Patch not applying | User must have the matching **Shorebird-built release** installed (not a debug APK) |
| `shorebird doctor` network errors | Check internet / firewall to api.shorebird.dev |
| iOS: no Podfile | `cd ios && pod init && pod install` |
| iOS: no Firebase plist | Add `GoogleService-Info.plist` to Runner |

---

## 9. Best Practices

1. **Never commit** `key.properties`, `.jks`, `.keystore`.
2. **Always run** `shorebird doctor` before a new machine/CI.
3. Test patches with `shorebird preview` before rolling out.
4. Keep `shorebird.yaml` committed to git (it isn't a secret).
5. Commit `pubspec.lock` and `shorebird.lock` (auto-created) to pin releases.
6. For any native change, bump the version and ship a **release**, not a patch.
7. Use **Internal/Closed testing** tracks for QA before Production rollout.

---

## 10. Command Cheat Sheet

```bash
# ============ Onboarding ============
shorebird login                       # authenticate
shorebird init --display-name="NIA HRMS"  # setup (already done)
shorebird doctor                      # health check

# ============ Android ============
flutter build apk --release           # plain APK (testing, non-Shorebird)
shorebird release android             # Shorebird release (AAB + APK)
shorebird patch android               # OTA update (Dart changes)
shorebird preview android             # test patch on device
shorebird release-status              # see releases/patches status

# ============ iOS ============
flutter build ios --release           # plain build (needs Mac)
shorebird release ios                 # Shorebird iOS release
shorebird patch ios                   # OTA update
shorebird preview ios                 # test patch

# ============ Help ============
shorebird --help
shorebird release --help
shorebird patch --help
```