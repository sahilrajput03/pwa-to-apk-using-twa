
**Quick Links:**
- **Convert your website into a native app:** [Click here](https://gonative.io/)
- **Readme2.md:** [Click here](Readme2.md)

# Bubblewrap

**Sample APK: [Click here](https://github.com/sahilrajput03/pwa-to-apk-using-twa/raw/main/bw.apk).**

Bubblewrap (npm): [Click here](https://www.npmjs.com/package/@bubblewrap/cli)

**Q. Url bar is showing up in the app?**

_Ans. We can hide url bar in apks generated using TWA. The problem with my app earlier was bcoz of asset-link verification failed. I debugged this by executing `adb logcat | grep -e OriginVerifier -e digital_asset_links` command and saw about this asset-link failure there. So the reason for this was bcoz I was using different package_name in the `domain.com/.well-known/assetlinks.json` and my android-project's application_id. We are suppose to set application_id for the andorid app during the initilization of the project i.e., when we run `bubblewrap init ...` command._

**Q. What does https://developers.google.com/digital-asset-links/tools/generator do?**

_Ans. We put our sha256 fingerprint (public key) contained in a json file i.e., `/.well-known/assetlinks.json` which we need to generate from above asset-link-tool-generator link. The good thing there is that we can use the test buton if the content is live at right place and the content is correct as well. So its a 2 two step process i.e., first you put your (domian, packageName (you get this from your `android-project`), SHA256 fingerprint) and then you update that your site and wait for the site to be up with the new data(you must be able to browse it via `yourdomian.com/.well-known/assetlinks.json` url)._

**Q. Where do I get `package_name`?**

_Ans. The package name you use must be same as the `application_id` which you set during the time you create your android-project via `bubblewrap init ...` command. If you forgot your application_id, you can you view it by going to `my-android-project/twa-manifest.json` file and look for `packageId` property._

**Q. How do I verify my `.well-known/assetlinks.json` file?**

Ans. Use this - https://developers.google.com/digital-asset-links/tools/generator
  
    ```txt
    Hosting site domain                     chetanmishra8660.github.io
    application_id (App package name):      io.github.chetanmishra8660.twa
    App package fingerprint (SHA256):       06:6F:45:81:9C:5D:40:12:D2:93:2F:79:27:49:47:96:FF:26:18:58:54:BA:0F:7F:D7:9B:08:DE:CE:E7:A9:81
    ```

**FYI: https://www.pwabuilder.com/ is also converting sites to apks, you can read @ https://www.davrous.com/2020/02/07/publishing-your-pwa-in-the-play-store-in-a-couple-of-minutes-using-pwa-builder/**

**official article that fireship.io used to make the tutorial: https://svenbudak.medium.com/this-twa-stuff-rocks-finally-i-got-my-pwa-on-google-play-store-b92fe8dae31f**

**Statement list generator(useful to create public key data for our website):** https://developers.google.com/digital-asset-links/tools/generator

```bash
###### INITIALIZE A ANDROID-PROJECT
#FYI: (You can use a existing keystore file or you would be asked to create new keystore file as well, fyi: I have tried creating my keystore file before this so I used that one and that flow worked really good{see later in this to know how to generate the keystore file})
mkdir p1 && cd p1
bubblewrap init --manifest https://chetanmishra8660.github.io/manifest.json

##### NOW A QUESTIONIARE WOULD FOLLOW UP AND FOR SOMETHING YOU MUST READ BELOW TEXT FOR ONCE TO SIDESTEP THE DIFFICULTIES I FACED BEFORE.
#1# -- important disclaimer for JAVA SDK you may supply path as I have concluded using some commands below but, for `androidtools` you must allow  bubblewrpa to install on its own. THATS IMPORTANT OTHERWISE bubblewrap build command won't work at all.
# ^^ src: https://github.com/GoogleChromeLabs/bubblewrap/issues/606

#2# Finding path of JDK path:
find /usr -name java | grep jdk
# Output:
# /usr/lib/jvm/java-17-openjdk/bin/java
# /usr/lib/jvm/java-11-openjdk/bin/java

# SO FROM ABOVE OUTPUT I CONCLUDED THAT MY JDK 11 PATH (coz with 17 bubblewrap throws error) is: /usr/lib/jvm/java-11-openjdk
# SRC: https://stackoverflow.com/a/5251365/10012446

#3# For maskable icon path:
https://1.bp.blogspot.com/-NIwZkk_DQIo/XWi8gswIAmI/AAAAAAAABxo/tgbMmy0hNv4tJj0E3lDJVXXrk07yASdOgCK4BGAYYCw/s320/android-chrome-512x512.png

#4# For keyname I used default i.e., android

#5# After above `bubblewrap init ...` is successful it prints message like:
# Output: Project generated successfully. Build it by running bubblewrap build

######### Building wiht bubblewrap ############
bubblewrap build
#6 Password for Key Store and Password for Key: 123456
```

## Generate Keystore file

```bash
# src: https://stackoverflow.com/a/15330139/10012446
keytool -genkey -v -keystore android.keystore -alias android -keyalg RSA -keysize 2048 -validity 10000
# I used password as 123456

# Getting SHA fingerprint from the keystore file (IMPORTANT: I didn't set passkey though)
keytool -list -v -keystore android.keystore -alias android -storepass 123456

#Save this SHA256 fingerprint: 06:6F:45:81:9C:5D:40:12:D2:93:2F:79:27:49:47:96:FF:26:18:58:54:BA:0F:7F:D7:9B:08:DE:CE:E7:A9:81
```

## Putting asset-link file on website

**Json generated from `https://developers.google.com/digital-asset-links/tools/generator` and uploading that to my site at path `/.well-known/assetlinks.json`**

ALSO since I was using jekyll at chetanmishra8660.github.io, simply putting anything in the root is not put into the final build when github generates the build so I had to do below fix.

In `_config.yml` in chetanmishra8660's repo I added,

```txt
include: [".well-known"]
```

and it worked yikes! src: https://pargorn.puttapirat.com/jekyll/2020/11/15/jekyll-well-known.html

File `assetlinks.json` belongs to `.well-known` folder in the repo(i.e., serving folder of the website).

## Other references:

- https://developer.chrome.com/docs/android/trusted-web-activity/integration-guide/#remove-url-bar
- https://github.com/GoogleChromeLabs/svgomg-twa/issues/35
- https://stackoverflow.com/questions/54597728/trusted-web-activity-address-bar-not-hide-chrome-for-android-72/72104959#72104959

**You don't need to do below manual stuff for generating any keystore or handling apk files and signing them because `bubblewrap build` command does all that for you. Bubblewrap rocks! ~Sahil**

```bash
# Generate a release apk
./gradlew assembleRelease

# Build apk is at:
# app/build/outputs/apk/release/app-release-unsigned.apk

# Copy release apk to current directory:
cp app/build/outputs/apk/release/app-release-unsigned.apk ./


### Below commands: SRC: https://stackoverflow.com/a/50706218/10012446
##### Use jarsigner (this will sign all the files in the apk using the public key
# from the keystore ~Sahil)
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ./android.keystore app-release-unsigned.apk android -storepass 123456

## CREATE EASY ALIASES FOR zipalign AND apksigner:
alias zipalign=/opt/android-sdk/build-tools/29.0.3/zipalign
alias apksigner=/opt/android-sdk/build-tools/29.0.3/apksigner

# Convert unsigned apk to signed apk
zipalign -v 4 app-release-unsigned.apk app-release-signed.apk
# Output: Verification Successful

apksigner verify android-prod-released-signed.apk
```

# Some WebApks

![image](https://github.com/sahilrajput03/pwa-to-apk-using-twa/assets/31458531/8903730e-9e60-46c3-900e-621c652bae87)
