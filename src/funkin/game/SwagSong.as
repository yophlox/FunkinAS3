package funkin.game
{
    public class SwagSong
    {
        public var song:String;
        public var notes:Array;
        public var bpm:int;
        public var needsVoices:Boolean;
        public var speed:Number;
        
        public var player1:String;
        public var player2:String;
        public var validScore:Boolean;
        
        public function SwagSong()
        {
            needsVoices = true;
            speed = 1;
            player1 = 'bf';
            player2 = 'dad';
            validScore = true;
        }
    }
} 