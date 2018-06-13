# Cordova-Plugin-Sync-Cookies
A cordova plugin to sync cookies for the very first run when the app is installed on the iPhone device.

Compatible with cordova plugin: [Plugin](https://github.com/apache/cordova-plugin-wkwebview-engine)

## Problem (in WKWebView)
When installing a fresh build of my application and attempting to log in, it fails because the authentication cookie sent by the server is never stored. Closing the application and re-launching fixes the issue.

## Solution
A native-code XHR function that javascript code can call. It makes that call, then the application needs to wait for at least 3 seconds on iPhone6 onwards and 12 seconds on iPhone5 before attempting further XHRs in your application. If you wait long enough, those XHRs will all fail because no cookies are remembered. But if it waits long enough then subsequent XHRs from javascript will have the cookies that were received from the native-code XHR.

## Usage
add this code either in `index.js` or `app.componenet.js`.

```
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	if (window.plugins.cookie) {
		window.plugins.cookie.executeXHR(SERVICE_URL, function (response) {
			// response: ok
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

## Credits
Grant Patterson: for providing native-code XHR function.
