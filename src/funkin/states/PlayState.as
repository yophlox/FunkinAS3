package funkin.states
{
    import engine.FunkinState;
    import flash.events.Event;
    import funkin.MusicBeatState;
    import funkin.game.Song;
    import funkin.game.Conductor;
    import funkin.game.SwagSong;
    import engine.FunkinGroup;
    import engine.FunkinSprite;
    import flash.geom.Point;
    import flash.display.Bitmap;

    public class PlayState extends MusicBeatState
    {
        public static var SONG:SwagSong;
        public static var songName:String = 'bopeebo';
        public static var difficulty:String = '-hard';

        private var strumLine:FunkinSprite;
        private var strumLineNotes:FunkinGroup;
        private var playerStrums:FunkinGroup;

        [Embed(source="../../../assets/images/NOTE_assets.png")]
        private static const NoteAssets:Class;

        [Embed(source="../../../assets/images/NOTE_assets.xml", mimeType="application/octet-stream")]
        private static const NoteAssetsXML:Class;

        override public function create():void
        {
            if (SONG == null)
                SONG = Song.loadFromJson(songName, difficulty);

            Conductor.mapBPMChanges(SONG);
            Conductor.changeBPM(SONG.bpm);

            trace("Song loaded: " + SONG.song);
            trace("Song bpm: " + SONG.bpm);

            super.create();

            strumLine = new FunkinSprite(50, 50);
            strumLineNotes = new FunkinGroup();
            playerStrums = new FunkinGroup();
            
            addChild(strumLineNotes);
            addChild(playerStrums);
            
            generateStaticArrows(0);
            generateStaticArrows(1);

            trace("strumLineNotes visible: " + strumLineNotes.visible);
            trace("playerStrums visible: " + playerStrums.visible);
            trace("strumLineNotes numChildren: " + strumLineNotes.numChildren);
            trace("playerStrums numChildren: " + playerStrums.numChildren);
        }
        
        private function generateStaticArrows(player:int):void
        {
            for (var i:int = 0; i < 4; i++)
            {
                var babyArrow:FunkinSprite = new FunkinSprite(0, strumLine.y);
                
                var bitmap:Bitmap = new NoteAssets();
                var xml:XML = new XML(new NoteAssetsXML());
                babyArrow.loadSparrowAtlas(bitmap, xml);

                babyArrow.animation_addByPrefix('green', 'arrowUP');
                babyArrow.animation_addByPrefix('blue', 'arrowDOWN');
                babyArrow.animation_addByPrefix('purple', 'arrowLEFT');
                babyArrow.animation_addByPrefix('red', 'arrowRIGHT');

                babyArrow.animation_addByPrefix('static', 'arrow static instance');
                babyArrow.animation_addByPrefix('pressed', player == 1 ? 'arrow push instance' : 'arrow press instance');
                babyArrow.animation_addByPrefix('confirm', 'arrow confirm instance');

                babyArrow.x += 50;
                babyArrow.x += ((stage.stageWidth / 2) * player);

                var spacing:Number = 125; 
                switch(i)
                {
                    case 0:
                        babyArrow.animation_play('purple');
                        babyArrow.x += 0;
                        break;
                    case 1:
                        babyArrow.animation_play('blue');
                        babyArrow.x += spacing;
                        break;
                    case 2:
                        babyArrow.animation_play('green');
                        babyArrow.x += spacing * 2;
                        break;
                    case 3:
                        babyArrow.animation_play('red');
                        babyArrow.x += spacing * 3;
                        break;
                }

                babyArrow.updateHitbox();
                babyArrow.scrollFactor = new Point(1, 1);

                babyArrow.ID = i;
                babyArrow.animation_play('static');
                babyArrow.scale.set(0.8, 0.8);
                babyArrow.updateHitbox();

                if (player == 1)
                {
                    playerStrums.add(babyArrow);
                }
                else
                {
                    strumLineNotes.add(babyArrow);
                }
            }
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