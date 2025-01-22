package engine
{
    import flash.events.KeyboardEvent;
    import flash.display.Stage;
    import flash.ui.Keyboard;
    
    public class FunkinInput
    {
        private static var _stage:Stage;
        private static var _keys:Object = {};
        private static var _justPressed:Object = {};
        private static var _justReleased:Object = {};
        private static var _initialized:Boolean = false;
        
        public static function init(stage:Stage):void
        {
            if (_initialized) return;
            
            _stage = stage;
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            _stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            _initialized = true;
        }
        
        private static function onKeyDown(e:KeyboardEvent):void
        {
            trace("Key pressed: " + e.keyCode);
            if (!_keys[e.keyCode])
            {
                _keys[e.keyCode] = true;
                _justPressed[e.keyCode] = true;
            }
        }
        
        private static function onKeyUp(e:KeyboardEvent):void
        {
            _keys[e.keyCode] = false;
            _justReleased[e.keyCode] = true;
        }
        
        public static function update():void
        {
            _justPressed = {};
            _justReleased = {};
        }
        
        public static function pressed(key:uint):Boolean
        {
            return _keys[key] == true;
        }
        
        public static function justPressed(key:uint):Boolean
        {
            return _justPressed[key] == true;
        }
        
        public static function justReleased(key:uint):Boolean
        {
            return _justReleased[key] == true;
        }
        
        public static function destroy():void
        {
            if (_stage)
            {
                _stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                _stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
                _stage = null;
            }
            _keys = {};
            _justPressed = {};
            _justReleased = {};
            _initialized = false;
        }
    }
}
