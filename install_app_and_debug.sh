adb install app-debug.apk && adb shell am start -n de.spectreos.battlestar/de.spectreos.battlestar.MainActivity && sleep 2 && adb logcat --pid=$(adb shell pidof -s de.spectreos.battlestar)
