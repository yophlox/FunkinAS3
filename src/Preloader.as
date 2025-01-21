package
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    
    [SWF(width="1280", height="720", backgroundColor="#000000")]
    public class Preloader extends Sprite
    {
        [Embed(source="../assets/preloaderArt.png")]
        private var LogoImage:Class;
        
        private var logo:Sprite;
        private var _width:Number;
        private var _height:Number;
        private var mainClassName:String = "Main";
        
        public function Preloader()
        {
            var mainRef:Class;
            if (Main) mainRef = Main;
            
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            _width = stage.stageWidth;
            _height = stage.stageHeight;
            
            var ratio:Number = _width / 2560;
            
            logo = new Sprite();
            var bitmap:Bitmap = new LogoImage();
            logo.addChild(bitmap);
            
            logo.scaleX = logo.scaleY = ratio;
            logo.x = (_width / 2) - (logo.width / 2);
            logo.y = (_height / 2) - (logo.height / 2);
            addChild(logo);
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onEnterFrame(e:Event):void
        {
            var percent:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 100;
            
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
            
            if (percent >= 100)
            {
                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                startup();
            }
        }
        
        private function startup():void
        {
            removeChild(logo);
            var mainClass:Class = Class(getDefinitionByName(mainClassName));
            addChild(new mainClass());
        }
    }
} 