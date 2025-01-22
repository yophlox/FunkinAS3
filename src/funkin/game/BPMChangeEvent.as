package funkin.game
{
    public class BPMChangeEvent
    {
        public var stepTime:int;
        public var songTime:Number;
        public var bpm:int;
        
        public function BPMChangeEvent(stepTime:int, songTime:Number, bpm:int)
        {
            this.stepTime = stepTime;
            this.songTime = songTime;
            this.bpm = bpm;
        }
    }
} 