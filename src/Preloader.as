package
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    import flash.utils.getTimer;
    import flash.media.Sound;
    
    [SWF(width="1280", height="720", backgroundColor="#000000")]
    public class Preloader extends Sprite
    {
        [Embed(source="../assets/preloaderArt.png")]
        public static var PreloaderArt:Class;
        
        [Embed(source="../assets/images/NOTE_assets.png")]
        public static var NoteAssets:Class;
        
        [Embed(source="../assets/images/NOTE_assets.xml", mimeType="application/octet-stream")]
        public static var NoteAssetsXML:Class;
        
        [Embed(source = "../assets/music/Bopeebo_Voices.mp3")]
        public static var BopeeboVoices:Class;
        
        [Embed(source = "../assets/music/Bopeebo_Inst.mp3")]
        public static var BopeeboInst:Class;
        
        [Embed(source="../assets/images/gfDanceTitle.png")]
        public static var GfImage:Class;
        
        [Embed(source="../assets/images/gfDanceTitle.xml", mimeType="application/octet-stream")]
        public static var GfXml:Class;
        
        [Embed(source="../assets/images/logoBumpin.png")]
        public static var LogoBumpImage:Class;
        
        [Embed(source="../assets/images/logoBumpin.xml", mimeType="application/octet-stream")]
        public static var LogoBumpXml:Class;
        
        [Embed(source="../assets/images/titleEnter.png")]
        public static var TitleEnterImage:Class;
        
        [Embed(source="../assets/images/titleEnter.xml", mimeType="application/octet-stream")]
        public static var TitleEnterXml:Class;
        
        [Embed(source="../assets/music/freakyMenu.mp3")]
        public static var MenuMusic:Class;
        
        [Embed(source="../assets/sounds/confirmMenu.mp3")]
        public static var ConfirmMenu:Class;
        
        public var logo:Sprite;
        public var _width:Number;
        public var _height:Number;
        public var mainClassName:String = "Main";
        public var loadedAssets:Array = [];
        public var startTime:Number;
        
        public function Preloader()
        {
            var mainRef:Class;
            if (Main) mainRef = Main;
            
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            startTime = getTimer();
            
            _width = stage.stageWidth;
            _height = stage.stageHeight;
            
            var ratio:Number = _width / 2560;
            
            logo = new Sprite();
            var bitmap:Bitmap = new PreloaderArt();
            logo.addChild(bitmap);
            
            logo.scaleX = logo.scaleY = ratio;
            logo.x = (_width / 2) - (logo.width / 2);
            logo.y = (_height / 2) - (logo.height / 2);
            addChild(logo);
            
            preloadAssets();
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function preloadAssets():void
        {
            loadedAssets.push(new NoteAssets());
            loadedAssets.push(new XML(new NoteAssetsXML()));
            
            loadedAssets.push(new BopeeboVoices());
            loadedAssets.push(new BopeeboInst());
            
            loadedAssets.push(new GfImage());
            loadedAssets.push(new XML(new GfXml()));
            loadedAssets.push(new LogoBumpImage());
            loadedAssets.push(new XML(new LogoBumpXml()));
            loadedAssets.push(new TitleEnterImage());
            loadedAssets.push(new XML(new TitleEnterXml()));
            loadedAssets.push(new MenuMusic());
            loadedAssets.push(new ConfirmMenu());
        }
        
        private function onEnterFrame(e:Event):void
        {
            var elapsed:Number = getTimer() - startTime;
            var percent:Number = Math.min((elapsed / 1000) * 100, 100); 
            
            if (percent < 69)
            {
                logo.scaleX += percent / 1920;
                logo.scaleY += percent / 1920;
                logo.x -= percent * 0.6;
                logo.y -= percent / 2;
            }
            else
            {
                logo.scaleX = _width / 1280;
                logo.scaleY = _width / 1280;
                logo.x = (_width / 2) - (logo.width / 2);
                logo.y = (_height / 2) - (logo.height / 2);
            }
            
            if (percent >= 100 && loadedAssets.length > 0)
            {
                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                startup();
            }
        }
        
        private function startup():void
        {
            loadedAssets = null;
            
            removeChild(logo);
            var mainClass:Class = Class(getDefinitionByName(mainClassName));
            addChild(new mainClass());
        }
    }
} 