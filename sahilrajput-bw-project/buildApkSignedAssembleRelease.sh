#!/usr/bin/env bash

# Note: Verify below variables exist in ~/.zprofile (macos) or `/etc/environment` (manjaro).
if [[ -z "$KEYSTORE_ALIAS" || -z "$KEYSTORE_PASSWORD" ]]; then
	echo "❌ Error: KEYSTORE_ALIAS and KEYSTORE_PASSWORD must be defined."
	exit 1
fi

if [[ "$USER" == "apple" ]]; then
	PROJECT_DIR='/Users/apple/Documents/github_repos/pwa-to-apk-using-twa/sahilrajput-bw-project' # MacOS
	export JAVA_HOME=/usr/local/opt/openjdk@11
else
	PROJECT_DIR='/home/array/test/pwa-to-apk-using-twa/sahilrajput-bw-project' # Manjaro

	# NOTE: This must be same as you configured the path to your jdk
	# when you first ran `bubblewrap init ...` command to set your JDK path.
	# Bubblewrap config file at ~/.bubblewrap/config.json
	export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
fi


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

if [ $? -eq 0 ]; then
	echo Build successful ✅ ✅
	### Uninstall old
	# adb uninstall com.sahilrajput.twa
	### Install APK
	adb install ./app/build/outputs/apk/release/app-release.apk
	# Kill activity (app)
	# adb shell am force-stop com.sahilrajput.twa
	# Open activity (app)
	adb shell am start -n com.sahilrajput.twa/.LauncherActivity
else
	echo Build Failed ❌ ❌
	exit 1
fi
