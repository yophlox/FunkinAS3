package funkin.game
{
    import funkin.game.SwagSong;
    import funkin.game.BPMChangeEvent;

    public class Conductor
    {
        public static var bpm:int = 100;
        public static var crochet:Number = ((60 / bpm) * 1000); // beats in milliseconds
        public static var stepCrochet:Number = crochet / 4; // steps in milliseconds
        public static var songPosition:Number;
        public static var lastSongPos:Number;
        public static var offset:Number = 0;
        
        public static var safeFrames:int = 10;
        public static var safeZoneOffset:Number = (safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds
        
        public static var bpmChangeMap:Array = []; // Array of BPMChangeEvent
        
        public function Conductor()
        {
        }
        
        public static function mapBPMChanges(song:SwagSong):void
        {
            bpmChangeMap = [];
            
            var curBPM:int = song.bpm;
            var totalSteps:int = 0;
            var totalPos:Number = 0;
            
            for (var i:int = 0; i < song.notes.length; i++)
            {
                if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
                {
                    curBPM = song.notes[i].bpm;
                    var event:BPMChangeEvent = new BPMChangeEvent(
                        totalSteps,
                        totalPos,
                        curBPM
                    );
                    bpmChangeMap.push(event);
                }
                
                var deltaSteps:int = song.notes[i].lengthInSteps;
                totalSteps += deltaSteps;
                totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
            }
            
            trace("new BPM map BUDDY " + bpmChangeMap);
        }
        
        public static function changeBPM(newBpm:int):void
        {
            bpm = newBpm;
            
            crochet = ((60 / bpm) * 1000);
            stepCrochet = crochet / 4;
        }
    }
}
