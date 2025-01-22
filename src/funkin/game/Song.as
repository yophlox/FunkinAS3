/*
Song.loadFromJson("song", "folder", function(song:SwagSong):void {
    // Do something with the loaded song
});
*/
package funkin.game
{
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import funkin.game.SwagSong;
    import funkin.states.PlayState;
    import com.adobe.serialization.json.JSON;
    
    public class Song
    {
        public var song:String;
        public var notes:Array;
        public var bpm:int;
        public var needsVoices:Boolean = true;
        public var speed:Number = 1;
        
        public var player1:String = 'bf';
        public var player2:String = 'dad';
        
        public function Song(song:String, notes:Array, bpm:int)
        {
            this.song = song;
            this.notes = notes;
            this.bpm = bpm;
        }
        
        [Embed(source="../../../assets/data/bopeebo.json", mimeType="application/octet-stream")]
        private static const BopeeboJson:Class;
        
        [Embed(source="../../../assets/data/bopeebo-easy.json", mimeType="application/octet-stream")]
        private static const BopeeboEasyJson:Class;
        
        [Embed(source="../../../assets/data/bopeebo-hard.json", mimeType="application/octet-stream")]
        private static const BopeeboHardJson:Class;
        
        public static function loadFromJson(songName:String, difficulty:String):SwagSong
        {
            var jsonText:String;
            
            switch(songName.toLowerCase() + difficulty.toLowerCase())
            {
                case "bopeebo":
                    jsonText = new BopeeboJson();
                    break;
                case "bopeebo-easy":
                    jsonText = new BopeeboEasyJson();
                    break;
                case "bopeebo-hard":
                    jsonText = new BopeeboHardJson();
                    break;
                default:
                    trace("Song not found: " + songName + difficulty);
                    var defaultSong:SwagSong = new SwagSong();
                    defaultSong.song = songName;
                    defaultSong.notes = [];
                    defaultSong.bpm = 100;
                    return defaultSong;
            }
            
            try {
                trace("Raw JSON text: " + jsonText);
                var loadedSong:SwagSong = parseJSONshit(jsonText);
                PlayState.SONG = loadedSong;
                return loadedSong;
            } catch (err:Error) {
                trace("Failed to parse song json: " + err.message);
                trace("Error at: " + err.getStackTrace());
                var errorSong:SwagSong = new SwagSong();
                errorSong.song = songName;
                errorSong.notes = [];
                errorSong.bpm = 100;
                return errorSong;
            }
        }
        
        private static function readFile(path:String):String
        {
            var loader:URLLoader = new URLLoader();
            loader.load(new URLRequest(path));
            
            while (!loader.data) { }
            
            return loader.data as String;
        }
        
        public static function parseJSONshit(rawJson:String):SwagSong
        {
            try {
                rawJson = rawJson.replace(/[\u0000-\u001F]/g, "");
                rawJson = rawJson.replace(/^\uFEFF/, ""); 
                
                var jsonObj:Object = com.adobe.serialization.json.JSON.decode(rawJson);
                var songData:Object = jsonObj.song;
                
                var swagShit:SwagSong = new SwagSong();
                swagShit.song = songData.song;
                swagShit.notes = songData.notes;
                swagShit.bpm = songData.bpm;
                swagShit.needsVoices = songData.needsVoices;
                swagShit.speed = songData.speed;
                swagShit.player1 = songData.player1;
                swagShit.player2 = songData.player2;
                swagShit.validScore = true;
                
                trace("Successfully parsed song data");
                return swagShit;
            } catch (err:Error) {
                trace("Error in parseJSONshit: " + err.message);
                throw err;
            }
        }
    }
}
