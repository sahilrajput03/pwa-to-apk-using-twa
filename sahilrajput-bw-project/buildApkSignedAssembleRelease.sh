#~/bin/bash
PROJECT_DIR='/home/array/test/p1'
# Note: Variable `KEYSTORE_PASSWORD` comes from my `/etc/environment` file.

# NOTE: This must be same as you configured the path to your jdk
# when you first ran `bubblewrap init ...` command to set your JDK path.
# Bubblewrap config file at ~/.bubblewrap/config.json
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# Note: This must be an absolute path else `gradlew` throws error key store file not found.
KEY_STORE_FILE="$PROJECT_DIR/play-console-android-06-oct-2023.keystore"

$PROJECT_DIR/gradlew \
	--project-dir $PROJECT_DIR/ assembleRelease \
	--warning-mode=all \
	-Pandroid.injected.signing.store.file="$KEY_STORE_FILE" \
	-Pandroid.injected.signing.store.password=$KEYSTORE_PASSWORD \
	-Pandroid.injected.signing.key.alias=android \
	-Pandroid.injected.signing.key.password=$KEYSTORE_PASSWORD

### FYI: Use this command to know all info of your keystore file:
# keytool -v -list -keystore android.keystore

### Uninstall old
adb uninstall com.sahilrajput.twa
### Install APK
adb install ./app/build/outputs/apk/release/app-release.apk

### (Learn: I can avoid doing this to save time!)
### Open app after install (nothing from below works, SAD)
# adb shell am start -n com.sahilrajput.twa/LauncherActivity
# adb shell am start -n com.sahilrajput.twa/com.google.androidbrowserhelper.trusted.ManageDataLauncherActivity
# adb shell am start -n com.sahilrajput.twa/com.google.androidbrowserhelper.trusted.FocusActivity
# adb shell am start -n com.sahilrajput.twa/com.google.com.google.androidbrowserhelper.trusted.WebViewFallbackActivity
# adb shell am start -n com.sahilrajput.twa/com.google.androidbrowserhelper.trusted.NotificationPermissionRequestActivity

# TODO: Do making of AAB file later (probably make second script for AAB generation)
# Generate AAB
# /app/build/outputs/bundle/release/..?
