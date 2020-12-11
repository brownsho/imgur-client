# imgur-client 

This project is a simple integration of the [**imgur api**](https://apidocs.imgur.com/) in Flutter.  
It was a school project at the very beginning but I decided to improve it.

## Configure API credentials

Before all, you must fill the informations in `lib/env.dart` :  

```dart
const api = {
	'clientID': 'imgur client id',
	'clientSecret': 'imgur client secret',
	'responseType': 'token',
	'state': 'imgur-client',
};
```
This will allow queries to the imgur api to work properly.  


## Features

- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media
