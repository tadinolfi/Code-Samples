package {	

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
    import flash.display.StageScaleMode;

	import noponies.net.LoadXml;
	import noponies.display.Xslides;
	import gs.TweenLite;

	public class As3_CrossFade extends Sprite {
		//private vars
		private var myloadXml:LoadXml;
		private var newSlides:Xslides;
		private var playPause:button_mc;
		private var pusharea:pusharea_mc;
		private var prg_txt:TextField
		private var status_txt:TextField
		private var thumbHolder:MovieClip;
		private var thumbLoader:Loader;
		private var thumbCount:int;
		private var thumbContainer:MovieClip;
		private var thumb:Bitmap;
		private var ct:int;
		
		public function As3_CrossFade() {
			preloader.visible = false;
			stage.align=StageAlign.TOP_LEFT;

			 //myloadXml = new LoadXml("gallery.xml?cachebuster=" + new Date().getTime());
			 myloadXml = new LoadXml("gallery.xml");
			//myloadXml = new LoadXml("http://manchesterautorental.com/vehicles/vehiclegallery/1");

			//myloadXml = new LoadXml("http://192.168.1.100:3000/vehicles/vehiclegallery/1");

			myloadXml.addEventListener(Event.COMPLETE, initSlides);
			//set the stage frame rate.
			stage.frameRate=31;
			//create a UI
			pusharea = new pusharea_mc();
			pusharea.alpha = .7;
			pusharea.x = 0;
			pusharea.y = 272;
			trace(this.height);
			addChild(pusharea);
			pusharea.left_mc.addEventListener(MouseEvent.MOUSE_UP, prevImg);
			pusharea.left_mc.addEventListener(MouseEvent.MOUSE_OUT, arrowOut);
			pusharea.left_mc.addEventListener(MouseEvent.MOUSE_OVER, arrowOver);
			pusharea.right_mc.addEventListener(MouseEvent.MOUSE_UP, nextImg);
			pusharea.right_mc.addEventListener(MouseEvent.MOUSE_OUT, arrowOut);
			pusharea.right_mc.addEventListener(MouseEvent.MOUSE_OVER, arrowOver);

			/*playPause = new button_mc();
			playPause.x = 400;
			playPause.y = 120;
			playPause.btn_txt.text = "PAUSE SLIDESHOW";
			playPause.addEventListener(MouseEvent.CLICK, playPauseSlides);
			addChild(playPause); */
			//progress text
			/*prg_txt = createDynTextField("")
			prg_txt.x = 400
			prg_txt.y = 150
			prg_txt.width = 220
			prg_txt.defaultTextFormat = createTextFormat(8, 0xFFFFFF, false,standard_07_65,0,0);
			addChild(prg_txt)
			//status text
			status_txt = createDynTextField("")
			status_txt.x = 400
			status_txt.y = 170
			status_txt.width = 220
			status_txt.defaultTextFormat = createTextFormat(8, 0xFFFFFF, false,standard_07_65,0,0);
			addChild(status_txt)*/
			
		}
		//create a new instance of the crossfading slideshow in the callback
		//handler of the XML parsing routine.

		private function initSlides(event:Event):void {
			newSlides = new Xslides(myloadXml.imagesArray);
			newSlides.xFadeTime = 3;
			newSlides.imageTime = 10;
			newSlides.slidesPlayRandom = false;
			newSlides.slidesLoop = true;
			newSlides.slidesAutoPlay = true;
			//Note, add to display list after class instance props are set..
			addChild(newSlides);
			//demo event listeners showing how you can listen in for slide events and the use of some of the 
			//classes getter functions to access information about each slide.
			newSlides.addEventListener(Event.OPEN, handleSlideOpen);
			newSlides.addEventListener(ProgressEvent.PROGRESS, handleSlideProgress);
			newSlides.addEventListener(Event.COMPLETE, handleSlideLoad);
			newSlides.addEventListener(Xslides.SLIDE_SHOW_COMPLETE, handleSlideShowComplete);
			this.addEventListener(MouseEvent.MOUSE_OVER, showPushArea);
			this.addEventListener(MouseEvent.MOUSE_OUT, hidePushArea);
			this.setChildIndex(pusharea, this.numChildren - 1);
			
			createThumbDisplay();

			
		}
		private function playPauseSlides(event:MouseEvent):void {
			if (!newSlides.slideShowPaused) {
				newSlides.dispatchEvent(new Event(Xslides.PAUSE_SLIDE_SHOW,true));
				playPause.btn_txt.text = "PLAY SLIDESHOW";
			} else {
				newSlides.dispatchEvent(new Event(Xslides.RESUME_SLIDE_SHOW,true));
				playPause.btn_txt.text = "PAUSE SLIDESHOW";
			}
		}
		private function prevImg(event:MouseEvent):void {
			newSlides.dispatchEvent(new Event(Xslides.PREV_SLIDE, true));
		}
		
		private function nextImg(event:MouseEvent):void {
			newSlides.dispatchEvent(new Event(Xslides.NEXT_SLIDE, true));
		}
		
		private function arrowOver(event:MouseEvent):void {
			MovieClip(event.currentTarget).gotoAndPlay('_over');
		}
		
		private function arrowOut(event:MouseEvent):void {
			MovieClip(event.currentTarget).gotoAndPlay('_up');
		}

		private function handleSlideLoad(event:Event):void {
			preloader.visible = false;
			//status_txt.text = "Slide number "+newSlides.currentImage+" of "+newSlides.totalSlides+" slides loaded";
		}
		private function handleSlideOpen(event:Event):void {
			pusharea.heading_txt.htmlText = myloadXml.headingArray[newSlides.currentImage];
			pusharea.subheading_txt.htmlText = myloadXml.subHeadingArray[newSlides.currentImage];
			trace("New slide "+newSlides.currentImageName+" requested");
		}
		private function handleSlideProgress(event:ProgressEvent):void {
			//this.setChildIndex(preloader, this.numChildren - 1);
			//preloader.visible = true;
			//var total:Number = event.bytesTotal;
			//var loaded:Number = event.bytesLoaded;
			//preloader.bar_mc.scaleX = loaded/total;
			//preloader.percent_txt.text = Math.floor((loaded/total)*100)+ "%";
			//percemt_txt.text = "Loaded "+event.bytesLoaded+" of "+event.bytesTotal+" or "+Math.round(100 * (event.bytesLoaded / event.bytesTotal))+" %"

			//prg_txt.text = "Loaded "+event.bytesLoaded+" of "+event.bytesTotal+" or "+Math.round(100 * (event.bytesLoaded / event.bytesTotal))+" %"
		}
		private function handleSlideShowComplete(event:Event):void {
			trace("Shows Over");
		}
		
		private function createThumbDisplay():void
		{
			this.thumbHolder = new MovieClip();
			addChild(thumbHolder);
			thumbHolder.y = 250;
			thumbHolder.x = 5;
//			trace("Length:" + myloadXml.thumbArray.length);
			this.thumbCount = 1;
			var rowcounter = 0;
			var colcounter = 0;
			for(var i:int = 0;i < myloadXml.thumbArray.length; i++)
			{
				trace("Count: " + i);
				thumbLoader = new Loader();
				thumbHolder.addChild(thumbLoader);

				//thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbLoaded);
				var request:URLRequest = new URLRequest(String(myloadXml.thumbArray[i]));//access our array of url's
				thumbLoader.load(request);
				//thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbCompleteHandler);
				if (i % 3 == 0)
				{

					colcounter = 0;
					rowcounter++;
				}
					thumbLoader.width = 100;
					thumbLoader.y = rowcounter * 110;

					thumbLoader.x = colcounter * 160;
					thumbLoader.addEventListener(MouseEvent.MOUSE_OVER, expandThumb);
					thumbLoader.addEventListener(MouseEvent.MOUSE_OUT, contractThumb);
					thumbLoader.addEventListener(MouseEvent.MOUSE_UP, showThumb);

					colcounter++;
					thumbLoader.alpha = .5;

				
			}
		}
		
		
		private function expandThumb(e:Event):void
		{
			thumbHolder.setChildIndex(Loader(e.target), thumbHolder.numChildren -1);
			TweenLite.to(e.currentTarget, 2, {alpha:1,overwrite:1});//alpha in the slides
			TweenLite.to(e.currentTarget, 1, {scaleX:1.2,overwrite:0});//alpha in the slides
			TweenLite.to(e.currentTarget, 1, {scaleY:1.2,overwrite:0});//alpha in the slides


		}
		
		private function contractThumb(e:Event):void
		{
			TweenLite.to(e.currentTarget, 2, {alpha:.5,overwrite:1});
			TweenLite.to(e.currentTarget, 1, {scaleX:1,overwrite:0});//alpha in the slides
			TweenLite.to(e.currentTarget, 1, {scaleY:1,overwrite:0});//alpha in the slides


		}
		
		private function showThumb(e:Event):void
		{
			var imgIndex:int = searchImageIndex(e.currentTarget.contentLoaderInfo.url);
			newSlides.openImage(imgIndex);
			//trace("Index: " + imgIndex);
		}
		
		private function searchImageIndex(url:String):int
		{
			//trace("URL1:" + url);
			//trace("Length:" + myloadXml.thumbArray.length);
			var path_start:int = url.search("/images");
			var actual_path:String = url.substr(path_start, url.length)
			for(var b = 0; b < myloadXml.thumbArray.length; b++)
			{

				if(actual_path == myloadXml.thumbArray[b])
				{
					//trace("URL2:"   + myloadXml.thumbArray[i]);
					//trace("Index1:" + i);
					var index = b;
				} 
			}
			return index;
		}
		
		private function thumbLoaded(e:Event):void
		{
			thumbContainer = new thumbnail();
			addChild(thumbContainer);
			thumb = Bitmap((thumbLoader.content));//create a sprite to load
			//thumb.alpha = 0;//set the slide content to have an alpha of 0
			thumb.x = 0;//position the slide content
			thumb.y = 0;//position the slide content
			thumb.alpha = .2;
			thumbLoader.unload()
			thumbLoader = null
			thumbContainer.addChild(thumb);
			thumbHolder.addChild(thumbContainer);
			thumbContainer.x = this.thumbCount * 96;
			this.thumbCount++;
			//TweenLite.to(thumb, crossFadeTime, {alpha:1, onComplete:onFinishAlpha});//alpha in the slides
		}
		
		//text field utility creation method
		//fileText = createDynTextField("Selected File: " + fileNameString)
		public static function createDynTextField(txt:String):TextField {
			var tf:TextField = new TextField()
			tf.type=TextFieldType.DYNAMIC;
			tf.autoSize=TextFieldAutoSize.LEFT;
			tf.embedFonts = true
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.multiline = true
			tf.wordWrap = false;
			tf.mouseEnabled=false;	
			tf.text = txt
			return tf;
		}
		
		//util textformat creaton function
		public static function createTextFormat(size:int, colour:int, weight:Boolean,font:Class, leading:int,kerning:Number):TextFormat {
			var tfFormat = new TextFormat();
			tfFormat.font = new font().fontName;//class name of font in parent library
			tfFormat.size=size;
			tfFormat.bold=weight;
			tfFormat.color=colour;
			tfFormat.letterSpacing=kerning;
			tfFormat.leading = leading;
			return tfFormat;
		}
		
		// pusharea
		public static function showPushArea(event:MouseEvent)
		{
			var myTween:TweenLite = new TweenLite(event.currentTarget.pusharea, 1, {alpha:0.7});
		}
		
		public static function hidePushArea(event:MouseEvent)
		{
			var myTween:TweenLite = new TweenLite(event.currentTarget.pusharea, 1, {alpha:0});
		}
		
		//The resizing function
	// parameters
	// required: mc = the movieClip to resize
	// required: maxW = either the size of the box to resize to, or just the maximum desired width
	// optional: maxH = if desired resize area is not a square, the maximum desired height. default is to match to maxW (so if you want to resize to 200x200, just send 200 once)
	// optional: constrainProportions = boolean to determine if you want to constrain proportions or skew image. default true.
	 private function resizeMe(mc:MovieClip, maxW:Number, maxH:Number=0, constrainProportions:Boolean=true):void{
		maxH = maxH == 0 ? maxW : maxH;
		mc.width = maxW;
		mc.height = maxH;
		if (constrainProportions) {
			mc.scaleX < mc.scaleY ? mc.scaleY = mc.scaleX : mc.scaleX = mc.scaleY;
		}
}


	}
}