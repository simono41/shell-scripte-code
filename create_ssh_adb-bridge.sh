adb pair 192.168.137.158:37983
adb connect 192.168.137.158:42261
adb devices
ssh -R 42261:spectreos.de:42261 -p1024
