function menus_init() {
	if (document.all && document.getElementById) {
		menuList = document.getElementsByTagName("UL");
		if (menuList.length > 0) {
			for (x=0; x<menuList.length; x++) {
				menuRoot = menuList[x];
				for (i=0; i<menuRoot.childNodes.length; i++) {
					menuNode = menuRoot.childNodes[i];
					if (menuNode.nodeName=="LI") {
						if (menuNode.className == "dropdown") {
							menuNode.onmouseover=function() {
								this.className+=" over";
							}
							menuNode.onmouseout=function() {
								this.className=this.className.replace(" over", "");
							}
						}
					}
				}
			}
		}
	}
}

// scott andrew (www.scottandrew.com) wrote this function. thanks, scott!
// adds an eventListener for browsers which support it.
function addEvent(obj, evType, fn) {
	if (obj.addEventListener){
		obj.addEventListener(evType, fn, true);
		return true;
	} else if (obj.attachEvent){
		var r = obj.attachEvent("on"+evType, fn);
		return r;
	} else {
		return false;
	}
}

addEvent(window, "load", menus_init);
