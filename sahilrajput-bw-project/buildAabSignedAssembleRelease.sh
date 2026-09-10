#~/bin/bash
PROJECT_DIR='/home/array/test/p1'
# Note: Variable `KEYSTORE_PASSWORD` comes from my `/etc/environment` file.

# NOTE: This must be same as you configured the path to your jdk
# when you first ran `bubblewrap init ...` command to set your JDK path.
# Bubblewrap config file at ~/.bubblewrap/config.json
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# Note: This must be an absolute path else `gradlew` throws error key store file not found.
KEY_STORE_FILE="$PROJECT_DIR/play-console-android-06-oct-2023.keystore"

### Generate AAB file
# Removing the aab file seems a safe choice because sometimes gradle doesn't generate file if it check existing file is good release on its own.
rm $PROJECT_DIR/app/build/outputs/bundle/release/app-release.aab 2>/dev/null
$PROJECT_DIR/gradlew \
	--project-dir $PROJECT_DIR bundleRelease \
	--warning-mode=all -Pandroid.injected.signing.store.file="$KEY_STORE_FILE" \
	-Pandroid.injected.signing.store.password=$KEYSTORE_PASSWORD \
	-Pandroid.injected.signing.key.alias=android \
	-Pandroid.injected.signing.key.password=$KEYSTORE_PASSWORD

# Generated AAB file path
# Relative path: ./app/build/outputs/bundle/release/app-release.aab
# Absolute path: /home/array/test/p1/app/build/outputs/bundle/release/app-release.aab
