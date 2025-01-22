package engine
{
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    public class FunkinState extends Sprite
    {
        public function FunkinState()
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void
        {
            if (hasEventListener(Event.ADDED_TO_STAGE))
                removeEventListener(Event.ADDED_TO_STAGE, init);
            
            create();
        }
        
        public function create():void {}
        
        public function update(elapsed:Number):void {}
        
        public function destroy():void {}
        
        public function add(Object:DisplayObject):DisplayObject
        {
            return addChild(Object);
        }
    }
} 