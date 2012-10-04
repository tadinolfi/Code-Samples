/*SIMPLE XML PARSING CLASS THAT RETURNS AN ARRAY OF IMAGES

SAMPLE USEAGE

In .fla
var myLoadXml:LoadXml = new LoadXml("images.xml");
myLoadXml.addEventListener(Event.COMPLETE, callbackHandler);

function callbackHandler(event:Event):void {
	var newSlides:Xslides = new Xslides(myLoadXml.imagesArray);
	addChild(newSlides)
}


Dale Sattler
www.blog.noponies.com
*/

package noponies.net{
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;

	public class LoadXml extends EventDispatcher {
		private var myXML:XML;
		private var myXLoader:URLLoader;
		private var myXMLURL:URLRequest;
		private var XML_URL:String;
		public var imagesArray:Array;
		public var headingArray:Array;
		public var subHeadingArray:Array;
		public var thumbArray:Array;
		
		
		public function LoadXml(url:String) {
			trace("URL:" + url);
			myXML = new XML();
			XML_URL = url;
			imagesArray = new Array;
			headingArray = new Array;
			subHeadingArray = new Array;			
			thumbArray = new Array;
			trace("URL:" + XML_URL);
			myXMLURL = new URLRequest(XML_URL);
			myXLoader = new URLLoader(myXMLURL);
			myXLoader.addEventListener(Event.COMPLETE, completeHandler);
			myXLoader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
		}
		private function completeHandler(event:Event):void {
			myXML = XML(event.target.data);
			trace("Length: " + myXML.slide.length());
			for (var i:int = 0; i < myXML.slide.length(); i++) {
					trace("Gallery: " + myXML.slide);
					imagesArray.push(myXML.slide.image[i]);
					headingArray.push(myXML.slide.image[i].@headline);
					subHeadingArray.push(myXML.slide.image[i].@pusharea);
					thumbArray.push(myXML.slide.image[i].@thumbpath);
				
			}
			dispatchEvent(event);
		}
		private function handleError(event:IOErrorEvent):void {
			throw new Error("There was an IOerror accessing the XML file: " + event);
		}
	}
}