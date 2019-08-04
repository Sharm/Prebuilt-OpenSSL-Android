# Prebuilt-OpenSSL-Android
Prebuilt shared OpenSSL 1.0.2s libraries for Android (armv7, arm64, x86) with build script. Correct .so name for Android!

Based on https://gitlab.com/2gisqtandroid/android-qt-openssl

* Configured as `shared` with default options.
* Patched Makefile for remove lib version after .so
* Used NDK: android-ndk-r13b
* Used android platform: android-21


# If you want to build it by yourself
1. Modify download script for correct openssl version
2. Run download script
3. Modify `options.sh` (android ndk required)
4. Run build.sh, check errors
