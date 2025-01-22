package engine
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getTimer;
    
    public class StateManager extends Sprite
    {
        private static var instance:StateManager;
        private var currentState:FunkinState;
        private var lastTime:Number;
        
        public function StateManager()
        {
            if (instance)
                throw new Error("StateManager is a singleton!");
                
            instance = this;
            lastTime = getTimer();
            addEventListener(Event.ENTER_FRAME, update);
        }
        
        public static function get Instance():StateManager
        {
            if (!instance)
                instance = new StateManager();
            return instance;
        }
        
        public function switchState(NewState:Class):void
        {
            if (currentState)
            {
                currentState.destroy();
                removeChild(currentState);
            }
            
            currentState = new NewState();
            addChild(currentState);
        }
        
        private function update(e:Event):void
        {
            var currentTime:Number = getTimer();
            var elapsed:Number = (currentTime - lastTime) / 1000;
            lastTime = currentTime;
            
            if (currentState)
                currentState.update(elapsed);
            
            FunkinInput.update();
        }
    }
} 