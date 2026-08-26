# Xiaomi Google Remote

MVP 0.1 Android project for a Xiaomi A-series Google TV remote.

## Build

The repository includes a GitHub Actions workflow. Open **Actions → Build APK → Run workflow**. The debug APK is uploaded as an artifact.

## Current MVP

- Remote control UI
- D-pad, OK, Home, Back
- Volume, Mute, Power controls
- Android Studio is not required for the cloud build

## Next protocol milestone

Implement Android TV Remote v2 discovery, TLS/PIN pairing, persistent credentials, reconnect, and protobuf key commands.
