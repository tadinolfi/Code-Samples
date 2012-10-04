/*	Unobtrusive Flash Objects (UFO) v1.01 <http://www.bobbyvandersluis.com/ufo/>
	Copyright 2005 Bobby van der Sluis
	This software is licensed under the CC-GNU LGPL <http://creativecommons.org/licenses/LGPL/2.1/>
	------------------------------
	v1.01 Fixed bug: Added missing quotes around attribute values
*/

var UFO = {
	requiredAttrParams: ["movie", "width", "height", "majorversion", "build"],
	optionalAttrEmb: ["name", "swliveconnect", "align"],
	optionalAttrObj: ["id", "align"],
	optionalAttrParams: ["play", "loop", "menu", "quality", "scale", "salign", "wmode", "bgcolor", "base", "flashvars", "devicefont", "allowscriptaccess"],
	
	create: function(FO, id) {
		UFO.setElementDisplay(id, "none");
		var loadfn = function() {
			if (UFO.hasRequiredAttrParams(FO) && UFO.hasFlashVersion(FO.majorversion, FO.build)) {
				UFO.writeFlashObject(FO, id);
			}
			UFO.setElementDisplay(id, "block");
		};
		UFO.addLoadEvent(loadfn);
	},

	setElementDisplay: function(id, display) {
		if (!document.createElement || !document.getElementsByTagName) return;
		var selector = "#" + id;
		var property = "display: " + display;
		var style = document.createElement("style");
		style.setAttribute("type", "text/css");
		style.setAttribute("media", "screen");
		document.getElementsByTagName("head")[0].appendChild(style);
		var agt = navigator.userAgent.toLowerCase(); 
		var is_ie = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));
		var is_win = (agt.indexOf("win") != -1);
		if (!(is_ie && is_win)) {
			var styles = document.getElementsByTagName("style");
			if (styles && styles.length > 0 && document.createTextNode) {
				var lastStyle = styles[styles.length - 1];
				var rule = document.createTextNode(selector + " {" + property + ";}");
				lastStyle.appendChild(rule); // Hopelessly bugs in IE/Win
			}
		}
		else if (document.styleSheets && document.styleSheets.length > 0) {
			var stylesheet = document.styleSheets[document.styleSheets.length - 1];
			if (typeof stylesheet.addRule == "object"){ // This test bugs in IE/Mac and Safari
				stylesheet.addRule(selector, property);
			}
		}
	},

	hasRequiredAttrParams: function(FO) {
		for (var i = 0; i < UFO.requiredAttrParams.length; i++) {
			if (typeof FO[UFO.requiredAttrParams[i]] == "undefined") return false;
		}
		return true;
	},
	
	hasFlashVersion: function(majorVersion, build) {
		var reqVersion = parseFloat(majorVersion + "." + build);
		if (navigator.plugins && typeof navigator.plugins["Shockwave Flash"] == "object") {
			var desc = navigator.plugins["Shockwave Flash"].description;
			if (desc) {
				var descArr = desc.split(" ");
				var majorArr = descArr[2].split(".");
				var major = majorArr[0];
				if (descArr[3] != "") {
					var minorArr = descArr[3].split("r");
				}
				else {
					var minorArr = descArr[4].split("r");
				}
				var minor = minorArr[1] > 0 ? minorArr[1] : 0;
				var flashVersion = parseFloat(major + "." + minor);
			}
		}
		else if (window.ActiveXObject) {
			try {
				var flash = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
				var desc = flash.GetVariable("$version");
				if (desc) {
					var descArr = desc.split(" ");
					var versionArr = descArr[1].split(",");        
					var major = versionArr[0];
					var minor = versionArr[2];
					var flashVersion = parseFloat(major + "." + minor);
				}
			}
			catch(e) {}
		}
		if (typeof flashVersion != "undefined"){
			return (flashVersion >= reqVersion ? true : false); 
		}
		return false;
	},

	writeFlashObject: function(FO, id) {
		if (!document.getElementById) return;
		var el = document.getElementById(id);
		if (typeof el.innerHTML == "undefined") return;
		var embHTML = "";
		var objAttrHTML = "";
		var objParamHTML = "";
		for (var i = 0; i < UFO.optionalAttrEmb.length; i++) {
			if (typeof FO[UFO.optionalAttrEmb[i]] != "undefined" && FO[UFO.optionalAttrEmb[i]] != "") {
				embHTML += ' ' + UFO.optionalAttrEmb[i] + '="' + FO[UFO.optionalAttrEmb[i]] + '"';
			}
		}
		for (var i = 0; i < UFO.optionalAttrObj.length; i++) {
			if (typeof FO[UFO.optionalAttrObj[i]] != "undefined" && FO[UFO.optionalAttrObj[i]] != "") {
				objAttrHTML += ' ' + UFO.optionalAttrObj[i] + '="' + FO[UFO.optionalAttrObj[i]] + '"';
			}
		}
		for (var i = 0; i < UFO.optionalAttrParams.length; i++) {
			if (typeof FO[UFO.optionalAttrParams[i]] != "undefined" && FO[UFO.optionalAttrParams[i]] != "") {
				embHTML += ' ' + UFO.optionalAttrParams[i] + '="' + FO[UFO.optionalAttrParams[i]] + '"';
				objParamHTML += '<param name="' + UFO.optionalAttrParams[i] + '" value="' + FO[UFO.optionalAttrParams[i]] + '" />';
			}
		}
		if (navigator.plugins && typeof navigator.plugins["Shockwave Flash"] == "object") {
			var foHTML = '<embed type="application/x-shockwave-flash" src="' + FO.movie + '" width="' + FO.width + '" height="' + FO.height + '" pluginspage="http://www.macromedia.com/go/getflashplayer"';
			foHTML += embHTML;
			foHTML += '></embed>';
		}
		else {
			var foHTML = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"' + objAttrHTML + ' width="' + FO.width + '" height="' + FO.height + '" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=' + FO.majorversion + ',0,' + FO.build + ',0">';
			foHTML += '<param name="movie" value="' + FO.movie + '" />';
			foHTML += objParamHTML;
			foHTML += '</object>';
		}
		el.innerHTML = foHTML;
	},

	addLoadEvent: function(fn) {
		if (window.addEventListener) {
			window.addEventListener("load", fn, false);
		}
		else if (document.addEventListener) {
			document.addEventListener("load", fn, false);
		}
		else if (window.attachEvent) {
			window.attachEvent("onload", fn);
		}
		else if (typeof window.onload == "function") {
			var fnOld = window.onload;
			window.onload = function(){
				fnOld();
				fn();
			};
		}
		else {
			window.onload = fn;
		}
	}
};
