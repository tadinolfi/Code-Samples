/*******************************************************************************
SIMPLE CROSS FADING ACTIONSCRIPT 3 SLIDESHOW CLASS
********************************************************************************

This class file is abstracted from its data source, which is an array of images. The class does not
handle any XML parsing, remoting etc. Rather, you pass an array of images and adjust the classes per instance settings
via its various getters and setters.

********************************************************************************
SETTINGS
********************************************************************************
Via setters, you can access and set the following properties for each slideshow instance..

xFadeTime: get/set - DataType:uint - Sets crossfade time or transition time between two slides in seconds
imageTime: get/set - DataType:uint - Sets total image display time, not including xFadeTime in seconds
slidesPlayRandom: get/set - DataType:Boolean - Sets the linear or random play order for slides. Set to true for random playback.
slidesLoop: get/set - DataType:Boolean - Sets whether the slideshow loops, or stops at end of images array. True = looping
slidesAutoPlay: get/set - DataType:Boolean - Sets whether the slides use the timer to auto progress, or whether a user must click on the slides to progress. True = autoPlay

********************************************************************************
SAMPLE USEAGE - NOTE: SET THE CLASSES PROPERTIES BEFORE YOU ADD IT TO THE DISPLAY LIST
********************************************************************************
Sample Useage
In a .fla or other class
var newSlides:Xslides = new Xslides(an Array of Image URLS);
newSlides.xFadeTime = 1;
newSlides.imageTime = 3;
newSlides.slidesPlayRandom = false;
newSlides.slidesLoop = true;
newSlides.slidesAutoPlay = true;
//Note, add to display list after class instance props are set..
addChild(newSlides);

Once the class is set up, you can listen for these events to create progress displays, track what slide is currently playing etc..
********************************************************************************
EVENTS
********************************************************************************
Class dispatches these events that correspond to various stages of loading and displaying slides
Event.OPEN - Dispatched with each request for a new slide
ProgressEvent.PROGRESS - Dispatched as slide loads
Event.COMPLETE - Dispatched once slide has loaded
Xslides.SLIDE_SHOW_COMPLETE - Dispatched only if slideshow is in non looping mode and the slideshow reaches the last image in the slidearray.

//demo event listeners showing how you can listen in for slide events and the use of some of the 
//classes getter functions to access information about each slide.
newSlides.addEventListener(Event.OPEN, handleSlideOpen);
newSlides.addEventListener(ProgressEvent.PROGRESS, handleSlideProgress);
newSlides.addEventListener(Event.COMPLETE, handleSlideLoad);
newSlides.addEventListener(Xslides.SLIDE_SHOW_COMPLETE, handleSlideShowComplete);

********************************************************************************
Version 1.2: Release 17 July, 2008 - Fixed Remove from stage error
********************************************************************************
Made by noponies in 2008
http://www.blog.noponies.com

Terms and Conditions for use
http://www.blog.noponies.com/terms-and-conditions

*********************************************************************************/
package noponies.display {
	import flash.display.Sprite;
	import gs.TweenLite;//using TweenLite to handle alpha fades
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Timer;

	public class Xslides extends Sprite {
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static  const SLIDE_SHOW_COMPLETE:String  = "slideshowcomplete";
		public static  const PAUSE_SLIDE_SHOW:String  = "pauseslideshow";
		public static  const RESUME_SLIDE_SHOW:String  = "resumeslideshow";
		public static  const NEXT_SLIDE:String = "nextslide";
		public static  const PREV_SLIDE:String = "prevslide";
		//--------------------------------------
		// PRIVATE INSTANCE VARS
		//--------------------------------------
		//access via getters/setters
		private var crossFadeTime:uint = 2;//SECONDS
		private var imageDisplayTime:uint = 10;//SECONDS
		private var randomXshow:Boolean = false;//random or linear slide progression
		private var looping:Boolean = true;//do the slides loop?
		private var autoSlideProgression:Boolean = false;//autoSlideProgression movement through slideshow
		private var pauseSlideShow:Boolean = false//var to track pausing/playing of slideshow. Get only!
		public var btnClicked:Boolean = false; // var to track if the prev or next button was clicked
		//internal vars
		private var contentHolder:Sprite;//the target sprite the slides load into
		private var p:int;//counter var
		private var slideArray:Array;//array of images
		private var loader:Loader;//loader for loading in images
		private var slide:Bitmap;//sprite that serves as a content holder for loaders content
		private var repeat:uint = 1;//timer repeat amount
		private var slideTimer:Timer = new Timer(imageDisplayTime*1000, repeat);//timer
		private var contentLoaded:Boolean = false
		
		//--------------------------------------
		// GETTERS/SETTERS
		//--------------------------------------
		//get crossFadeTime
		public function get xFadeTime():uint {
			return crossFadeTime;
		}
		//set crossFadeTime
		public function set xFadeTime(newXFadeTime:uint):void {
			crossFadeTime = newXFadeTime
		}		
		//get imageDisplayTime
		public function get imageTime():uint {
			return imageDisplayTime;
		}
		//set imageDisplayTime
		public function set imageTime(newImageDisplayTime:uint):void {
			imageDisplayTime = newImageDisplayTime
			slideTimer.delay = imageDisplayTime*1000
		}
		//set random or ordered slideShow
		public function get slidesPlayRandom():Boolean{
			return randomXshow
		}
		public function set slidesPlayRandom(randomOrder:Boolean):void{
			randomXshow = randomOrder
		}
		//set get slideShow looping
		public function get slidesLoop():Boolean{
			return looping
		}
		public function set slidesLoop(loop:Boolean):void{
			looping = loop
		}
		//set get autoSlideProgression or auto playback
		public function get slidesAutoPlay():Boolean{
			return autoSlideProgression
		}
		public function set slidesAutoPlay(auto:Boolean):void{
			autoSlideProgression = auto
		}
		//get total slides
		public function get totalSlides():int{
			return slideArray.length
		}
		//get current slide num
		public function get currentImage():int{
			return p
		}
		//get current slide file name
		public function get currentImageName():String{
			return slideArray[p]
		}
		//get current slideshow play status
		public function get slideShowPaused():Boolean{
			return pauseSlideShow
		}
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		public function Xslides(slideArray:Array) {
			this.contentHolder = new Sprite();
			addChild(contentHolder)
			this.slideArray = slideArray;
			addEventListener(Event.ADDED_TO_STAGE,addedToStage)
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage)
			addEventListener(Xslides.PAUSE_SLIDE_SHOW, handleSlideShowPause)
			addEventListener(Xslides.RESUME_SLIDE_SHOW, handleSlideShowResume)
			addEventListener(Xslides.NEXT_SLIDE, handleNextSlide)
			addEventListener(Xslides.PREV_SLIDE, handlePrevSlide)
		}
		//--------------------------------------
		// PRIVATE INSTANCE METHODS
		//--------------------------------------
		private function addedToStage(event:Event):void{
			//initial slide start position value
			if (randomXshow) {
				p = Math.floor((Math.random()*slideArray.length));
			} else {
				p = 0;
			}
			//call the image loader function
			loadImage();
			//add a timer event listener or mouse click if we are not in autoSlideProgression mode
			slideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, loadImage);
			if (!autoSlideProgression) {
				contentHolder.addEventListener(MouseEvent.CLICK, loadImage);
			}
		}
		//main load image function
		private function loadImage(event:Event = null) {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openHandler);
			if (event != null) {
				trace(event.type);
			}

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);		
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			var request:URLRequest = new URLRequest(String(slideArray[p]));//access our array of url's
			if (event != null)
			{
				if (event.type == "timerComplete" && !randomXshow)
				{
					p++;
				}
				trace(event.type)
			}
			loader.load(request);
			contentLoaded = false

		}
		/*COMPLETE Event Call Back function, does the work of the slideshow.  The timer is reset, new slides are faded into place and old slides
		are removed, the p counter variable is incremented and the timer is restarted*/

		private function loaded(event:Event):void {
			
			if(autoSlideProgression){
				slideTimer.reset();//reset the timer
			}
			
			
			
			slide = Bitmap((loader.content));//create a sprite to load
			slide.alpha = 0;//set the slide content to have an alpha of 0
			slide.x = 0;//position the slide content
			slide.y = 0;//position the slide content
			loader.unload()
			loader = null
			contentHolder.addChild(slide);
			TweenLite.to(slide, crossFadeTime, {alpha:1, onComplete:onFinishAlpha});//alpha in the slides

		
			function onFinishAlpha():void {
				dispatchEvent(new Event(Event.COMPLETE,true, false));
				if(autoSlideProgression){
				//check to see if we are looping or not, if we are, kill the timer and stop at this last slide
				if (!looping && p==slideArray.length) {
					slideTimer.reset();
				} 
				}
				slideTimer.start();
				/*check here to see if we have a slide existing, delete it if we do
				takes advantage of AS3's depth manager shuffling the slides clip depths
				for us.*/
				if (contentHolder.numChildren>1) {
					var tempBit:Bitmap = Bitmap(contentHolder.getChildAt(0))
					tempBit.bitmapData.dispose()
					tempBit = null
					contentHolder.removeChildAt(0);
					
				}
				contentLoaded = true
			}
			/*reset the p counter variable based on if we have a random or linear slide show, and also check to see that the
			value is not beyond the total number of images we actually have in our array.*/
			//if we are not sposed to loop, and we are in random mode, we need to remove items from the slide array to force the
			//slide show to stop when all possible images have been displayed
			if(!looping && randomXshow){
					slideArray.splice(p,1)
					if(slideArray.length ==0){
						dispatchEvent(new Event(Xslides.SLIDE_SHOW_COMPLETE,true));
					}
				}
				
			if (!randomXshow) {
				//p++;
			} else {
				p = Math.floor((Math.random()*slideArray.length));
			}
			if (!randomXshow && p==slideArray.length && looping) {
				p =0;
			}
			if (!randomXshow && p==slideArray.length && !looping) {
				dispatchEvent(new Event(Xslides.SLIDE_SHOW_COMPLETE,true));
			}
		}
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
		//open event handler, simply redispatch
		private function openHandler(event:Event):void{
			dispatchEvent(event);
		}
		//load progress handler, simply redispatch the progress event at class scope level
		private function handleProgress(event:ProgressEvent):void {
			dispatchEvent(event)
		}
		
		//rudimentary IO Error handling
		private function onIOError(event:IOErrorEvent):void {
			trace("There was an IOerror accessing the image file: " + event);
		}
		//handler for pause slideshow events. First set the bool that tracks slideshow pause status
		//then reset the timer. The reason we use both a var and reset the timer is that the timer
		//may not actually be running when we get a pause event, as the slideshow might be loading an image
		//the bool is checked against in the class when it add the main image display timer.
		private function handleSlideShowPause(event:Event):void{
			pauseSlideShow = true
			slideTimer.reset()
		}
		//restart the slideshow if it is paused
		private function handleSlideShowResume(event:Event):void{
			pauseSlideShow = false
			slideTimer.start()
		}
		//handle removal from stage
		private function removedFromStage(event:Event):void{
			try {
			if(loader !=null){
				loader.close()
			}
			slideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, loadImage);
			removeEventListener(Xslides.PAUSE_SLIDE_SHOW, handleSlideShowPause)
			removeEventListener(Xslides.RESUME_SLIDE_SHOW, handleSlideShowResume)
			slideTimer.reset()
			//kill any tweens running through tweenLite
			if(!contentLoaded){
			TweenLite.killTweensOf(slide, false);
			}
			slideArray = null
			slide = null
			contentHolder = null
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStage)
			} catch (e:Error) {
				throw new Error("There was an error when attempting to delete all slide content: "+Error);
			}
		}
		
		private function handleNextSlide(event:Event):void {
			//trace(event.type);
			trace("Number: " + p);
			slideTimer.reset();
			if (!randomXshow && p==slideArray.length - 1 && looping) {
				p =0;
			} else {
				p++;
			}
			loadImage(event);
		}
		
		public function openImage(index:int):void
		{
			slideTimer.reset();
			p = index;
			loadImage();
		}
		
		private function handlePrevSlide(event:Event):void {
			slideTimer.reset();
			trace("Number: " + p);
			if (p > 0)
			{
				p--;
			}
			
			loadImage(event);
		}

	}

}
/*//fade alpha function
		//will run slower if the screen is being resized.
	private function fadeTimerListener(event:TimerEvent) {
			slide.alpha += .01;
			if (slide.alpha >= 1) {
				fadeTimer.removeEventListener(TimerEvent.TIMER, fadeTimerListener);
				fadeTimer.reset();
				onFinishAlpha();
		}
		event.updateAfterEvent();
	}
		
	private function onFinishAlpha():void {
			//stuff
}*/