# Overmaps

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/bebc173017684c0db197fa10ab538c39)](https://app.codacy.com/gh/xcarol/overmaps/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

**Explore two locations concurrently with transparent map overlays.**  

Discover a new dimension of exploration with Overmaps, an app that redefines the way you compare and analyse two different locations using Google Maps. With the unique ability to overlay two maps with transparency, Overmaps empowers you to delve into intricate details seamlessly. Here are the key features:  

- Search Different Locations:
    Use the search bar to input addresses or names of locations you want to explore.
    Find and select two distinct areas for a comprehensive comparison.

- Map Overlay:
    Once you've chosen the locations, effortlessly overlay them.
    Fine-tune transparency using an intuitive control slider for a detailed view of each location.

- Individual Rotation:
    Customize the perspective of each location with individual rotation option.
    Rotate and adjust the angle of each map to achieve the best visualization.

- Maintained Zoom:
    Apply desired zoom to one location, and watch it seamlessly transition to the other map.
    Simplifies the comparison of details and features between two geographic areas.

- Easy Navigation:
    Navigate smoothly between the two locations with a simple toggle or interface gesture.

Overmaps provides a fresh and innovative way to gain insights into two locations simultaneously, aiding decision-making and in-depth geographical analysis. Download our app today and embark on a unique exploration experience!

## Google Maps Key

Set _MAPS_API_KEY_ environment variable at _./android/secrets.properties_  for the android app  
Set _--dart-define=MAPS_API_KEY=key_ when running _flutter_

## Firebase & Crashlytics

Got configuration steps from _https://firebase.google.com/docs/crashlytics/get-started?platform=flutter_  

First login to Firebase  

    firebase login

Then run

    flutterfire configure

and select  

✔ Select a Firebase project to configure your Flutter application with · overmap-1503847389383 (Overmaps)  
✔ Which platforms should your configuration support (use arrow keys & space to select)? · android, web  

to generate the files  

    google-services.json
    firebase_options.dart

### VSCODE

Set in _.vscode/launch.json_

    "configurations": [
        {
          "name": "overmaps",
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
    storeFile=/home/xcarol/workspace/overmaps/upload-keystore.jks (Stored in BitWarden)  

- _local.properties_

    sdk.dir=/home/xcarol/workspace/android-sdk/  
    flutter.sdk=/home/xcarol/snap/flutter/common/flutter  
    flutter.buildMode=release  
    flutter.versionName=1.0.0  
    flutter.versionCode=1  

- _secrets.properties_

    MAPS_API_KEY=key  

    _"key" is stored at [Google APIs](https://console.cloud.google.com/apis/credentials/key/266?project=overmap-1503847389383)_

### Build

#### Bundle

`flutter build appbundle --release --dart-define=MAPS_API_KEY=key`

#### Web

`flutter build web --release --dart-define=MAPS_API_KEY=key`

- MAPS_API_KEY "key" is the same used in the _secrets.properties_.  

## Application signing and publishing

As this is a one time process, I cannot step back to do the process again, so here I leave useful information in case it is needed do this process again. God willing 🤞😅.  

Links to follow:  

<https://docs.flutter.dev/deployment/android>  
<https://developer.android.com/studio/publish/app-signing#enroll_new>  
<https://play.google.com/console>  

The keystore (and password) used for the app signing is at the Bitwarden vault. These are the same used in the _key.properties_ file.  

### Publishing a new version for internal test

- Modify the last (build) number in _version: 1.0.0+**X**_ at the _pubspec.yaml_ file before building the new .aab bundle.

- Build the bundle (as explained above): `flutter build appbundle --release --dart-define=MAPS_API_KEY=key`

- Go to: [Create an internal test version](https://play.google.com/console/u/0/developers/5602401961225582177/app/4974805149532825109/app-dashboard) to upload it.
