# Cordova-Plugin-Sync-Cookies
A cordova plugin to sync cookies for the very first run when the app is installed on the iPhone device.

Compatible with cordova plugin: [Plugin](https://github.com/apache/cordova-plugin-wkwebview-engine)

## Problem (in WKWebView)
When installing a fresh build of the application and attempting to log in, it fails because the authentication cookie sent by the server is never stored. Closing the application and re-launching fixes the issue.

## Solution
A native-code XHR function that javascript code can call. It makes that call, then the application **needs to wait** for atleast **3 seconds on iPhone6 and onwards** and **12 seconds on iPhone5** before attempting further XHRs in your application. If you don't wait long enough, those XHRs will all fail because no cookies are remembered. But if you wait long enough then subsequent XHRs from javascript will have the cookies that were received from the native-code XHR.

## Usage
add this code either in `index.js` or `app.componenet.ts`.

```
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	if (window.plugins.cookie) {
		window.plugins.cookie.executeXHR(SERVICE_URL, function (response) {
			// response: ok
			// wait atleast 3 seconds on iPhone6 and onwards and
			// 12 seconds on iPhone5 and then call other XHRs.
		}, function (error) {
			console.log("error: " + error);
		});
	}
}
```

SERVICE_URL: can be any dummy json object e.g:
```
{
  "remark": "this file is loaded at startup of the IOS app to synchronize important cookies in advance"
}
```

## Extra
you can use this code below to get:
- Detect device app or desktop
- Detect iPhone or any other device
- Get iOS version number and change timeout accordingly
- Timeout for first time and then normal for all other runs

```
const app = document.URL.indexOf( 'http://' ) === -1 && document.URL.indexOf( 'https://' ) === -1;
let isIphone = false;
let iOSVersionTimeout = 3000; // 3 secs

if (app) {
	let agent = window.navigator.userAgent;
	let start = agent.indexOf( 'OS ' );
	isIphone = (agent.indexOf( 'iPhone' ) > -1) && start > -1 

	if(isIphone) { // if device is iPhone
	  let iOSVersion = window.Number(agent.substr( start + 3, 3 ).replace( '_', '.' ));
	  if(iOSVersion < 11) {
	    iOSVersionTimeout = 12000; // 12 secs
	  }
	}
}

// logic: app or desktop
if(app && isIphone && localStorage.getItem('ALREADY_LAUNCHED') === null) { // run first time on app only
	setTimeout( () => {
	  // start your next XHR requests
	}, iOSVersionTimeout);

	// save item
	localStorage.setItem("ALREADY_LAUNCHED", "true");
} else {
	// start your next XHR requests
}
```

## Credits
Grant Patterson: for providing native-code XHR function.
