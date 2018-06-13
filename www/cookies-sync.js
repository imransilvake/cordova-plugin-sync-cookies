function CookiesSync() { }

/**
 * method: executeXHR
 *
 * @param message
 * @param successCallback
 * @param errorCallback
 */
CookiesSync.prototype.executeXHR = function (message, successCallback, errorCallback) {
	cordova.exec(successCallback, errorCallback, "CookiesSync", "executeXHR", [message]);
};

CookiesSync.install = function () {
	if (!window.plugins) {
		window.plugins = {};
	}

	window.plugins.cookie = new CookiesSync();
	return window.plugins.cookie;
};

cordova.addConstructor(CookiesSync.install);
