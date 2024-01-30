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

## Icons

The [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) tool is used to generate the icons for different platforms  

The file used as the app logo is _./lib/assets/logo.png_  

After updating the logo run:  $ `dart run flutter_launcher_icons`

