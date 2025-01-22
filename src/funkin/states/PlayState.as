package funkin.states
{
    import engine.FunkinState;
    import flash.events.Event;
    import funkin.MusicBeatState;
    import funkin.game.Song;
    import funkin.game.Conductor;
    import funkin.game.SwagSong;
    
    public class PlayState extends MusicBeatState
    {
        public static var SONG:SwagSong;
        public static var songName:String = 'bopeebo';
        public static var difficulty:String = '-hard';

        override public function create():void
        {
            if (SONG == null)
                SONG = Song.loadFromJson(songName, difficulty);

            Conductor.mapBPMChanges(SONG);
            Conductor.changeBPM(SONG.bpm);

            trace("Song loaded: " + SONG.song);
            trace("Song bpm: " + SONG.bpm);

            super.create();
        }
        
        override public function update(elapsed:Number):void
        {
            super.update(elapsed);
        }
        
        override public function destroy():void
        {
            super.destroy();
        }
    }
} 