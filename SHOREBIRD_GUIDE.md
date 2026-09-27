# Shorebird developer command guide — NIA HRMS

Windows PowerShell guide. Commands requirement ke hisaab se chalayein;
poori file ek saath execute nahi karni hai. Verified on 20 September 2026
against installed Shorebird CLI 1.6.120 and official documentation.

- Shorebird app: `aeon_hrms`
- App ID: `b20be92e-607f-4653-9ca6-759fd65ddc36`
- Android application ID: `com.app.nia_hrms`
- Automatic patch downloads are enabled in `shorebird.yaml`.
- Current project version: `1.0.0+3`; last verified releases: `1.0.0+2`, `1.0.0+3`.
- Flutter baseline: `3.47.2`. Future versions ke liye live release list check karein.

## Check access and configuration

```powershell
shorebird account apps
shorebird doctor
```

If the app is not listed, log in with an account that has access. Do not
reinitialize an existing app just to resolve an account access error.

## Build a baseline APK release

```powershell
shorebird release android --artifact apk --flutter-version 3.47.2
```

This builds for ARM32, ARM64, and x86_64 by default. Distribute the universal APK;
do not add `--split-per-abi` or restrict `--target-platform`.

Install/distribute the APK path printed by Shorebird. Users must install this
Shorebird-built release before they can receive patches. The Android project
currently signs releases with the debug key, which is suitable for testing.
Configure the proper release/upload keystore before a Play Store submission;
preserve the signing identity for updates to an already distributed app.

## Patch an existing release

After a compatible Dart code change, use the exact installed release version:
Keep `version: 1.0.0+3` for patches targeting this baseline. Saving files or
pushing to GitHub does not publish a patch; run the following command explicitly.

```powershell
shorebird patch android --release-version 1.0.0+3
```

Automatic updates download in the background and apply on a subsequent launch.
For asset changes or native code/dependency changes that require a new binary, increment the
version in `pubspec.yaml`, create a new release, and distribute the new APK.

Do not use `shorebird init --force` for routine releases or patches: it creates
a new app identity. Keep `shorebird.yaml` and `pubspec.lock` in source control.

Official documentation: https://docs.shorebird.dev/code-push/release/

## 1. Roz ke kaam ke commands

Project root se commands run karein:

```powershell
Set-Location 'D:\Ram Nivas Singh\Aeon Mobile New Version\Aapl_hrms\nia_hrms'

# Server par published release versions dekhein
shorebird releases list

# Published release se universal APK generate/download karein
shorebird releases get-apks --release-version 1.0.0+3

# Dart/UI changes installed 1.0.0+3 users ko publish karein
shorebird patch android --release-version 1.0.0+3

# Published patches aur actual patch numbers dekhein
shorebird patches list --release-version 1.0.0+3
```

Direct patch command default stable track par publish karti hai. Pehle staging
testing karna ho to section 5 follow karein. Sirf Git push se patch nahi jaati.

## 2. Login, account aur diagnosis

```powershell
# Installed CLI/Flutter version
shorebird --version

# Browser mein login; har build se pehle zaroori nahi
shorebird login

# Logged-in account
shorebird account whoami

# Accessible apps aur app IDs
shorebird account apps

# Accessible organizations
shorebird account orgs

# Network/project health checks
shorebird doctor

# Automatically fixable issues repair; changes git diff mein review karein
shorebird doctor --fix

# Account switch: logout, phir correct account se login
shorebird logout
shorebird login

# Shorebird CLI update
shorebird upgrade
```

## 3. Initialize — sirf naya setup

Is project mein initialization ho chuki hai. Routine release/patch ke liye
dobara init na karein.

```powershell
# Existing Flutter project ka first-time Shorebird setup
shorebird init --display-name "NIA HRMS"

# Bilkul naya Flutter project banayein; existing project ke andar na chalayein
shorebird create my_new_app
```

Organization ke liye `shorebird account orgs` se ID lein aur
`shorebird init --help` mein `--organization-id` option dekhein.

**Sirf jaan-boojhkar nayi app identity chahiye tab:**

```powershell
shorebird init --force --display-name "NIA HRMS"
```

Ye config overwrite karke nayi app ID banata hai. Purani ID wali installed APK
ko nayi ID ki patches nahi milengi. Account access error ka routine fix nahi hai.

## 4. New release aur existing release mein difference

Nayi baseline ke liye pehle `shorebird releases list` dekhein. Example:
`1.0.0+4` unused ho to `pubspec.yaml` mein set karein:

```yaml
version: 1.0.0+4
```

```powershell
flutter pub get

# Universal APK + AAB build aur baseline publish
shorebird release android --artifact apk --flutter-version 3.47.2
```

Normal output paths, project root ke relative:

- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

Final **Published Release** message verify karein. Sirf local APK banne se
server publication successful hona prove nahi hota.

Alternate commands; same version ke liye sab ek ke baad ek publish na karein:

```powershell
# AAB release, APK generation request nahi karta
shorebird release android --flutter-version 3.47.2

# Build/validation only, upload/publish nahi
shorebird release android --artifact apk --flutter-version 3.47.2 --dry-run

# Smaller ARM64-only APK; ye universal NAHI hogi
shorebird release android --artifact apk --target-platform android-arm64 --flutter-version 3.47.2

# Existing published release ki details
shorebird releases info --release-version 1.0.0+3

# Existing AAB se universal APK; nayi release/patch publish nahi hoti
shorebird releases get-apks --release-version 1.0.0+3

# Custom output folder
shorebird releases get-apks --release-version 1.0.0+3 --out ./build/shorebird-apks

# ABI-wise APKs; universal chahiye to ye flag mat lagayein
shorebird releases get-apks --release-version 1.0.0+3 --no-universal
```

Original signed APK distribution ke liye prefer karein. Regenerated APK existing
installation replace na kare to signing certificate check karein. Plain
`flutter build apk` Shorebird baseline ka substitute nahi hai.

## 5. Patch staging, test aur stable publication

Installed baseline ka exact version use karein. `1.0.0+3` patch `1.0.0+2`
users ko nahi milegi. Older release ko support karna ho to uske compatible
source/dependencies se alag patch banayein, ya new APK install karayein.
Patch ke liye baseline version increment nahi karna hai.

```powershell
# Optional build/validation without publishing
shorebird patch android --release-version 1.0.0+3 --dry-run

# Pehle staging par publish karein
shorebird patch android --release-version 1.0.0+3 --track staging

# Actual generated patch number dekhein
shorebird patches list --release-version 1.0.0+3

# Connected Android device/emulator par staging test karein
shorebird preview --platform android --release-version 1.0.0+3 --track staging
```

App internet ke saath kholein, patch download hone dein, process completely
close karke dobara launch karein. New behavior test karein. Test pass hone ke
baad neeche `1` ko ACTUAL patch number se replace karein:

```powershell
# Tested patch stable users ko activate karein; rebuild nahi hoti
shorebird patches promote --release-version 1.0.0+3 --patch-number 1
```

Direct stable shortcut:

```powershell
shorebird patch android --release-version 1.0.0+3
```

Patch command matching release ka Flutter version khud select karti hai;
`patch` mein `--flutter-version` pass nahi karna hai.

## 6. Patch details, tracks, rollback aur rollforward

`1` example patch number hai; list se actual number lein. Neeche mutation
commands users/server state ko affect karti hain; zaroorat par hi chalayein.

```powershell
# Patch details
shorebird patches info --release-version 1.0.0+3 --patch-number 1

# Chosen track assign karein
shorebird patches set-track --release-version 1.0.0+3 --patch-number 1 --track staging

# Stable promotion ka alternate command
shorebird patches set-track --release-version 1.0.0+3 --patch-number 1 --track stable

# Problematic patch roll back karein
shorebird patches rollback --release-version 1.0.0+3 --patch-number 1

# Previously rolled-back patch reactivate karein
shorebird patches rollforward --release-version 1.0.0+3 --patch-number 1
```

Rollback open screen turant replace nahi karta; device update check aur next
app launch par effect aata hai. App/release delete karna rollback ka substitute
nahi hai. Version `1.0.0+3` aur patch number `3` alag cheezein hain.

## 7. Device preview aur update behavior

```powershell
# Release/device interactively choose karein
shorebird preview

# Specific release stable preview
shorebird preview --platform android --release-version 1.0.0+3 --track stable

# Connected device IDs
flutter devices
```

Specific device ke liye preview mein `--device-id DEVICE_ID` add karein;
`DEVICE_ID` ko actual ID se replace karein.

`auto_update: true` launch par background download enable karta hai. Downloaded
patch NEXT full launch par apply hoti hai; ye live hot reload nahi hai.
Internet, app ID, installed release version aur track match hona zaroori hai.
Android app mein ab patch fully download hone par mandatory bottom sheet aati
hai. Sirf **Restart now** option hai; Later/back/swipe dismissal disabled hai.
Startup, foreground resume aur foreground mein har 15 minute stable update check
hota hai. Restart button separate Android helper process se main app process
restart karta hai, jisse pending patch load ho sakti hai. Tracking ki saved active
preference change nahi hoti; startup par existing service setup use restore karta hai.
Restart se pehle service GPS callbacks pause karke in-flight SQLite write finish
karti hai, phir acknowledgement deti hai. 20-second timeout/failure par restart
abort hota hai aur tracking resume request hoti hai. UI disappear ho to service
ka 30-second watchdog bhi tracking restore karta hai. New app startup location
service ko WorkManager setup se independently restore karta hai. Unsynced rows
database mein rehti hain aur existing sync flow unhe send karta hai. Restart mein
brief GPS gap possible hai; physical device par active attendance ke saath test karein.

### Restart bottom sheet ko pehli baar ship karna

Is feature mein native MainActivity/manifest/helper Activity change hai. Ise old
`1.0.0+3` baseline par patch karke distribute NA karein. `shorebird releases list`
se unused version choose karein (example `1.0.0+4`), pubspec mein set karein,
phir `shorebird release android --artifact apk --flutter-version 3.47.2` run karein.
Users ko ye nayi APK ek baar install karni hogi. Iske baad isi NEW release version
par compatible Dart patches publish karein. Production checker stable use karta
hai; canary patch ko testing ke baad stable promote karein.

## 8. Kaunse changes patch ho sakte hain?

- Compatible Dart logic, text, layout, API handling: patch use karein.
- Kotlin/Java, AndroidManifest, Gradle, native plugins: new APK release.
- New/changed images, bundled fonts/assets: new APK release.
- New Material icons tree-shaken font badal sakte hain: asset warning check karein.
- Dependency changes: native/assets impact check karein; automatically safe nahi.

`--allow-native-diffs` / `--allow-asset-diffs` warnings bypass karne ke routine
shortcuts nahi hain. Unsupported changes installed APK mein nahi pahunchengi.

## 9. Flutter versions, cache aur extra flags

```powershell
# Available Shorebird Flutter versions
shorebird flutter versions list

# Shorebird Flutter configuration inspect karein
shorebird flutter config
shorebird flutter config --help

# Sirf cache issues par; next build dependencies dobara download kar sakti hai
shorebird cache clean

# Local Flutter outputs clear karein; har patch se pehle zaroori nahi
flutter clean
flutter pub get
```

PowerShell mein extra Flutter arguments ka separator quote karein. Example
syntax-only hai; API_ENV tabhi effect karega jab app use read karti ho.
Baseline/patch mein relevant build defines consistent rakhein.

```powershell
shorebird release android --artifact apk --flutter-version 3.47.2 '--' --dart-define=API_ENV=production
```

Future configured flavors/entrypoints ke liye `--flavor` / `--target` options
hain. Is project mein bina configured flavor ke flag add na karein.

## 10. iOS aur other platforms

iOS ke liye macOS + Xcode + signing required hai. Is Windows machine par iOS
build nahi hogi. Mac par iOS setup complete hone ke baad:

```powershell
shorebird release ios
shorebird patch ios --release-version 1.0.0+3
shorebird preview --platform ios --release-version 1.0.0+3
```

iOS patch ko published iOS baseline chahiye; Android release enough nahi hai.
Desktop/platform-specific flags `shorebird release --help` aur
`shorebird patch --help` se dekhein; Android setup unka validation nahi hai.

## 11. Common errors aur fixes

### Release not found

```powershell
shorebird releases list
shorebird releases info --release-version 1.0.0+3
```

Exact version copy karein: `1.0.0+3` aur `11.0.0+3` alag hain.
Sirf pubspec version edit se server release nahi banti. Missing baseline ke
liye pehle release successfully publish karein.

### Could not find app / permission denied

```powershell
shorebird account whoami
shorebird account apps
Get-Content shorebird.yaml
```

Correct account/app access verify karein. Team owner se access lein ya correct
account login karein. Android package name Shorebird UUID ki jagah mat lagayein.

### Version already released

Dart-only update ke liye patch karein. New baseline ke liye unused version/build
number pubspec mein set karke release karein.

### Patch phone par nahi dikh rahi

Shorebird-built APK, matching ID/version, correct stable/staging track, active
patch aur internet check karein. Download ke baad app process completely
close/reopen karein; Home button se background/foreground full restart nahi hai.

### Build/network failure

```powershell
shorebird doctor

# Failed command mein --verbose add karke details lein
shorebird releases info --release-version 1.0.0+3 --verbose
```

Release/patch retry se pehle server status check karein; timeout ke bawajood
publication ho chuki ho sakti hai. CLI printed log file inspect karein.
Logs share karne se pehle tokens/sensitive build defines redact karein.

## 12. Full command help aur CI

```powershell
shorebird --help
shorebird account --help
shorebird init --help
shorebird create --help
shorebird login --help
shorebird logout --help
shorebird doctor --help
shorebird upgrade --help
shorebird release --help
shorebird releases --help
shorebird releases get-apks --help
shorebird patch --help
shorebird patches --help
shorebird preview --help
shorebird flutter --help
shorebird flutter versions --help
shorebird cache --help
```

Kisi subcommand ke baad `--help` se all flags milenge. Installed CLI mein
`shorebird apps` ki jagah `shorebird account apps` valid hai.
`shorebird login:ci` removed hai; CI ke liye Console Account > API Keys aur
official CI docs follow karein. API key repository mein commit na karein.
Supported command ke structured output ke liye `--json` use karein; ye
non-interactive mode bhi enable karta hai, required arguments explicitly dein.

## References

- [Initialization](https://docs.shorebird.dev/code-push/initialize/)
- [Releases and get-apks](https://docs.shorebird.dev/code-push/release/)
- [Patch management](https://docs.shorebird.dev/code-push/patch/)
- [Preview](https://docs.shorebird.dev/code-push/preview/)
- [Staging workflow](https://docs.shorebird.dev/code-push/guides/staging-patches/)
- [Automatic updates](https://docs.shorebird.dev/code-push/update-strategies/)
- [CI setup](https://docs.shorebird.dev/code-push/ci/generic/)
- [Console](https://console.shorebird.dev)
