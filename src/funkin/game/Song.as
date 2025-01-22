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
    
    public class Song
    {
        public var song:String;
        public var notes:Array; // Array of SwagSection
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
        
        public static function loadFromJson(jsonInput:String, folder:String = null, callback:Function = null):void
        {
            var path:String = 'assets/data/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase() + '.json';
            var loader:URLLoader = new URLLoader();
            
            loader.addEventListener(Event.COMPLETE, function(e:Event):void {
                var rawJson:String = loader.data.toString().trim();
                
                while (!rawJson.charAt(rawJson.length - 1) == "}")
                {
                    rawJson = rawJson.substr(0, rawJson.length - 1);
                }
                
                if (callback != null)
                    callback(parseJSONshit(rawJson));
            });
            
            loader.load(new URLRequest(path));
        }
        
        private static function readFile(path:String):String
        {
            // In AS3, we need to handle file loading differently
            // This is a synchronous version - you might want to make this async
            var loader:URLLoader = new URLLoader();
            loader.load(new URLRequest(path));
            
            // Wait for load to complete
            while (!loader.data) { }
            
            return loader.data as String;
        }
        
        public static function parseJSONshit(rawJson:String):SwagSong
        {
            var jsonObj:Object = JSON.parse(rawJson);
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
            
            return swagShit;
        }
    }
}
