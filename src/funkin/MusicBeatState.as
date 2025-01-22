package funkin
{
    import engine.FunkinState;
    import flash.events.Event;
    import funkin.game.BPMChangeEvent;
    import funkin.game.Conductor;
    import flash.utils.getTimer;
    
    public class MusicBeatState extends FunkinState
    {
        public var lastBeat:Number = 0;
        public var lastStep:Number = 0;
        public var curStep:int = 0;
        public var curBeat:int = 0;

        override public function create():void
        {
            super.create();
        }
        
        override public function update(elapsed:Number):void
        {
            Conductor.songPosition = getTimer();
            
            var oldStep:int = curStep;
            updateCurStep();
            updateBeat();

            if (oldStep != curStep && curStep > 0)
                stepHit();

            super.update(elapsed);
        }

        private function updateBeat():void
        {
            curBeat = Math.floor(curStep / 4);
        }

        private function updateCurStep():void
        {
            var lastChange:BPMChangeEvent = new BPMChangeEvent(0, 0, 0);
            
            for (var i:int = 0; i < Conductor.bpmChangeMap.length; i++)
            {
                if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
                    lastChange = Conductor.bpmChangeMap[i];
            }

            curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
        }

        public function stepHit():void
        {
            if (curStep % 4 == 0)
                beatHit();
        }

        public function beatHit():void
        {
            //do literally nothing dumbass
        }
        
        override public function destroy():void
        {
            super.destroy();
        }
    }
} 