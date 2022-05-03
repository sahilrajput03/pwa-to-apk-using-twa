#!/bin/bash
# Setting aliases
alias zipalign=/opt/android-sdk/build-tools/29.0.3/zipalign
alias apksigner=/opt/android-sdk/build-tools/29.0.3/apksigner
shopt -s expand_aliases

./gradlew assembleRelease
cp app/build/outputs/apk/release/app-release-unsigned.apk ./
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ./android.keystore app-release-unsigned.apk android -storepass 123456
zipalign -v 4 app-release-unsigned.apk app-release-signed.apk
apksigner verify android-prod-released-signed.apk
