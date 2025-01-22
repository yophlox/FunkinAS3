package engine
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.getTimer;
    import flash.display.Shape;
    
    public class FunkinTimer extends EventDispatcher
    {
        private static var _shape:Shape;
        private static var _timers:Array = [];
        
        private var _time:Number;
        private var _loops:int;
        private var _callback:Function;
        private var _startTime:Number;
        private var _running:Boolean;
        
        {
            if (_shape == null)
            {
                _shape = new Shape();
                _shape.addEventListener(Event.ENTER_FRAME, updateTimers);
            }
        }
        
        public function FunkinTimer(Time:Number = 1)
        {
            _time = Time;
            _running = false;
        }
        
        public function start(Time:Number = -1, Callback:Function = null, Loops:int = 1):FunkinTimer
        {
            if (Time > 0)
                _time = Time;
                
            _callback = Callback;
            _loops = Loops;
            _startTime = getTimer() / 1000;
            _running = true;
            
            _timers.push(this);
            return this;
        }
        
        private static function updateTimers(e:Event):void
        {
            var currentTime:Number = getTimer() / 1000;
            
            for (var i:int = _timers.length - 1; i >= 0; i--)
            {
                var timer:FunkinTimer = _timers[i];
                if (timer._running)
                {
                    var elapsed:Number = currentTime - timer._startTime;
                    
                    if (elapsed >= timer._time)
                    {
                        if (timer._callback != null)
                            timer._callback(timer);
                            
                        timer._loops--;
                        
                        if (timer._loops <= 0)
                            timer.destroy();
                        else
                            timer._startTime = currentTime;
                    }
                }
            }
        }
        
        public function destroy():void
        {
            _running = false;
            var index:int = _timers.indexOf(this);
            if (index != -1)
                _timers.splice(index, 1);
            _callback = null;
        }
    }
}