# Overmap

Visually compare locations using Google Maps

## Google Maps Key

Set _MAPS_API_KEY_ environment variable at _./android/secrets.properties_  for the android app  
Set _--dart-define=MAPS_API_KEY=key_ when running _flutter_

### VSCODE

Set in _.vscode/launch.json_

    "configurations": [
        {
          "name": "overmap",
          "request": "launch",
          "type": "dart",
          "toolArgs": [
            "--dart-define=MAPS_API_KEY=key"
          ]
        }
      ]

- MAPS_API_KEY "key" is the same used in the _secrets.properties_.  

## Icons

The [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) tool is used to generate the icons for different platforms  

The file used as the app logo is _./lib/assets/logo.png_  defined in the _pubspec.yaml_ file under the _flutter_launcher_icons_ section.  

After updating the logo run:  $ `dart run flutter_launcher_icons`

## Build and run Android App

Setup these files:  

- _key.properties_

    storePassword=(Stored in BitWarden)  
    keyPassword=(Stored in BitWarden)  
    keyAlias=upload  
    storeFile=/home/xcarol/workspace/overmap/upload-keystore.jks (Stored in BitWarden)  

- _local.properties_

    sdk.dir=/home/xcarol/workspace/android-sdk/  
    flutter.sdk=/home/xcarol/snap/flutter/common/flutter  
    flutter.buildMode=release  
    flutter.versionName=1.0.0  
    flutter.versionCode=1  

- _secrets.properties_

    MAPS_API_KEY=key  

    _"key" is stored at [Google APIs](https://console.cloud.google.com/apis/credentials/key/266?project=overmap-1503847389383)_

### Build bundle

`flutter build appbundle --dart-define=MAPS_API_KEY=key`

- MAPS_API_KEY "key" is the same used in the _secrets.properties_.  

## Application signing and publishing

As this is a one time process, I cannot step back to do the process again, so here it is useful information in case it is needed do this process again. God willing 🤞😅.  

Links to follow:  

<https://docs.flutter.dev/deployment/android>  
<https://developer.android.com/studio/publish/app-signing#enroll_new>  
<https://play.google.com/console>  

The keystore (and password) used for the app signing is at the Bitwarden vault. These are the same used in the _key.properties_ file.  

### Publishing a new version for internal test

Modify the last (build) number in _version: 1.0.0+**X**_ at the _pubspec.yaml_ file before building the new .aab bundle.

The build the bundle (as explained above) and go to: [Create an internal test version](https://play.google.com/console/u/0/developers/5602401961225582177/app/4974106073607129188/tracks/4701415689677472096/releases/7/prepare) to upload it.
