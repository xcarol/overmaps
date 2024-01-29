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
