#!/bin/bash
# Debug via `--verbose` of nodemon to know which files triggered restart and add
#   unnecessary to --ignore option.
nodemon -e java,xml,gradle --ignore ./app/src/main/res/xml/shortcuts.xml -x './gradlew installDebug && adb shell am start -n com.sahilrajput.twa/.LauncherActivity'
