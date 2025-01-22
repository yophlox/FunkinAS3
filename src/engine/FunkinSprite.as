package engine
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import flash.utils.Dictionary;
    import flash.xml.XMLDocument;
    import flash.display.DisplayObject;
    
    public class FunkinSprite extends Sprite
    {
        protected var _frames:Dictionary;
        protected var _animations:Dictionary;
        protected var _curAnim:String;
        protected var _curFrame:int;
        protected var _frameTimer:Number;
        protected var _frameRate:Number;
        
        public var angle:Number = 0;
        public var scale:Point;
        
        protected var _frameWidth:int = 0;
        protected var _frameHeight:int = 0;
        public var graphic:Bitmap;
        protected var _pixels:BitmapData;
        
        public function FunkinSprite(X:Number = 0, Y:Number = 0)
        {
            this.x = X;
            this.y = Y;
            scale = new Point(1, 1);
            graphic = new Bitmap();
            addChild(graphic);
            
            _frames = new Dictionary();
            _animations = new Dictionary();
            _frameTimer = 0;
            _frameRate = 30;
        }
        
        public function loadGraphic(Graphic:Class, Animated:Boolean = false, Width:int = 0, Height:int = 0):FunkinSprite
        {
            var bitmap:Bitmap = new Graphic();
            _pixels = bitmap.bitmapData;
            
            if (Width == 0)
            {
                Width = _pixels.width;
                Height = _pixels.height;
            }
            
            _frameWidth = Width;
            _frameHeight = Height;
            
            graphic.bitmapData = _pixels;
            graphic.smoothing = false;
            
            return this;
        }
        
        public function makeGraphic(Width:int, Height:int, Color:uint = 0xFFFFFFFF):FunkinSprite
        {
            _pixels = new BitmapData(Width, Height, true, Color);
            _frameWidth = Width;
            _frameHeight = Height;
            
            graphic.bitmapData = _pixels;
            graphic.smoothing = false;
            
            return this;
        }
        
        public function loadSparrowAtlas(Graphic:*, XMLData:XML):FunkinSprite
        {
            trace("FunkinSprite: Loading atlas...");
            var bitmap:Bitmap = (Graphic is Bitmap) ? Graphic : new Bitmap(Bitmap(Graphic).bitmapData);
            _pixels = bitmap.bitmapData;
            
            var frames:XMLList = XMLData.SubTexture;
            trace("FunkinSprite: Found", frames.length(), "frames");
            
            for each(var frame:XML in frames)
            {
                var name:String = String(frame.@name);
                var rect:Rectangle = new Rectangle(
                    Number(frame.@x),
                    Number(frame.@y),
                    Number(frame.@width),
                    Number(frame.@height)
                );
                
                var sourceWidth:Number = frame.hasOwnProperty("@frameWidth") ? 
                    Number(frame.@frameWidth) : Number(frame.@width);
                var sourceHeight:Number = frame.hasOwnProperty("@frameHeight") ? 
                    Number(frame.@frameHeight) : Number(frame.@height);
                    
                var offsetX:Number = frame.hasOwnProperty("@frameX") ? 
                    Number(frame.@frameX) : 0;
                var offsetY:Number = frame.hasOwnProperty("@frameY") ? 
                    Number(frame.@frameY) : 0;
                
                var sourceSize:Point = new Point(sourceWidth, sourceHeight);
                var offset:Point = new Point(offsetX, offsetY);
                
                _frames[name] = new SparrowFrame(
                    name,
                    rect,
                    String(frame.@rotated) == "true",
                    String(frame.@trimmed) == "true",
                    sourceSize,
                    offset
                );
            }
            
            trace("FunkinSprite: Atlas loaded successfully");
            return this;
        }
        
        public function animation_add(Name:String, Frames:Array, FrameRate:Number = 30, Loop:Boolean = true):void
        {
            _animations[Name] = {frames: Frames, frameRate: FrameRate, loop: Loop};
        }
        
        public function animation_play(Name:String, Force:Boolean = false):void
        {
            if (_curAnim == Name && !Force)
                return;
                
            _curAnim = Name;
            _curFrame = 0;
            _frameTimer = 0;
            _frameRate = _animations[Name].frameRate;
            updateFrame();
        }
        
        protected function updateFrame():void
        {
            if (!_curAnim || !_animations[_curAnim])
            {
                trace("FunkinSprite: No current animation");
                return;
            }
                
            var frameName:String = _animations[_curAnim].frames[_curFrame];
            var frame:SparrowFrame = _frames[frameName];
            
            if (!frame)
            {
                trace("FunkinSprite: Frame not found:", frameName);
                return;
            }
            
            var frameData:BitmapData = new BitmapData(
                Math.ceil(frame.frame.width),
                Math.ceil(frame.frame.height),
                true,
                0x00000000
            );
            
            frameData.copyPixels(
                _pixels,
                frame.frame,
                new Point(0, 0)
            );
            
            if (graphic)
            {
                graphic.bitmapData = frameData;
                graphic.x = frame.offset.x;
                graphic.y = frame.offset.y;
            }
            else
            {
                trace("FunkinSprite: Graphic is null!");
            }
        }
        
        public function update(elapsed:Number):void
        {
            if (_curAnim && _animations[_curAnim])
            {
                _frameTimer += elapsed;
                if (_frameTimer >= 1 / _frameRate)
                {
                    _frameTimer = 0;
                    _curFrame++;
                    
                    var anim:Object = _animations[_curAnim];
                    if (_curFrame >= anim.frames.length)
                    {
                        if (anim.loop)
                            _curFrame = 0;
                        else
                            _curFrame = anim.frames.length - 1;
                    }
                    
                    updateFrame();
                }
            }
        }
        
        override public function get width():Number
        {
            return _frameWidth * scale.x;
        }
        
        override public function get height():Number
        {
            return _frameHeight * scale.y;
        }
        
        public function setGraphicSize(Width:int = 0, Height:int = 0):void
        {
            if (Width <= 0 && Height <= 0)
                return;
                
            scale.x = Width / _frameWidth;
            scale.y = Height / _frameHeight;
            
            if (Width <= 0)
                scale.x = scale.y;
            if (Height <= 0)
                scale.y = scale.x;
                
            graphic.scaleX = scale.x;
            graphic.scaleY = scale.y;
        }
        
        public function updateHitbox():void
        {
            graphic.scaleX = scale.x;
            graphic.scaleY = scale.y;
        }
        
        public function destroy():void
        {
            if (_pixels)
                _pixels.dispose();
                
            if (graphic && contains(graphic))
                removeChild(graphic);
                
            _pixels = null;
            graphic = null;
            scale = null;
        }
        
        public function animation_addByIndices(Name:String, Prefix:String, Indices:Array, Postfix:String = "", FrameRate:Number = 30, Loop:Boolean = true):void
        {
            var frameArray:Array = [];
            for each(var index:int in Indices)
            {
                var frameName:String = Prefix + padNumber(index, 4) + Postfix;
                frameArray.push(frameName);
            }
            animation_add(Name, frameArray, FrameRate, Loop);
        }
        
        public function animation_addByPrefix(Name:String, Prefix:String, FrameRate:Number = 30, Loop:Boolean = true):void
        {
            var frameArray:Array = [];
            
            for (var frameName:String in _frames)
            {
                if (frameName.indexOf(Prefix) == 0)
                {
                    frameArray.push(frameName);
                }
            }
            
            frameArray.sort();
            
            animation_add(Name, frameArray, FrameRate, Loop);
        }
        
        private function padNumber(number:int, width:int):String 
        {
            var str:String = number.toString();
            while (str.length < width) {
                str = "0" + str;
            }
            return str;
        }
    }
}