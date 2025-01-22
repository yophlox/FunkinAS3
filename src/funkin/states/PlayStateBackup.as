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
    import flash.utils.getTimer;
    import funkin.game.Note;
    import engine.FunkinSound;
    import flash.media.Sound;
    import flash.net.URLRequest;
    import Preloader;

    public class PlayState extends MusicBeatState
    {
        public static var SONG:SwagSong;
        public static var songName:String = 'bopeebo';
        public static var difficulty:String = '-hard';

        private var strumLine:FunkinSprite;
        private var strumLineNotes:FunkinGroup;
        private var playerStrums:FunkinGroup;

        private var unspawnNotes:Array = [];
        private var notes:FunkinGroup;
        private var vocals:Sound;
        private var inst:Sound;
        private var generatedMusic:Boolean = false;
        private var startingSong:Boolean = false;
        private var songStarted:Boolean = false;
        private var previousFrameTime:Number = 0;
        private var songTime:Number = 0;
        private var paused:Boolean = false;

        override public function create():void
        {
            previousFrameTime = getTimer();

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
            notes = new FunkinGroup();
            
            addChild(strumLineNotes);
            addChild(playerStrums);
            addChild(notes);
            
            generateStaticArrows(0);
            generateStaticArrows(1);

            trace("strumLineNotes visible: " + strumLineNotes.visible);
            trace("playerStrums visible: " + playerStrums.visible);
            trace("strumLineNotes numChildren: " + strumLineNotes.numChildren);
            trace("playerStrums numChildren: " + playerStrums.numChildren);

            generateSong(SONG.song);
        }
        
        private function generateStaticArrows(player:int):void
        {
            for (var i:int = 0; i < 4; i++)
            {
                var babyArrow:FunkinSprite = new FunkinSprite(0, strumLine.y);
                
                var bitmap:Bitmap = new Preloader.NoteAssets();
                var xml:XML = new XML(new Preloader.NoteAssetsXML());
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

        private function generateSong(songName:String):void
        {
            var songData:SwagSong = SONG;
            Conductor.changeBPM(songData.bpm);
            
            if (SONG.needsVoices)
            {
                vocals = new Preloader.BopeeboVoices();
            }
            else
            {
                vocals = new Sound();
            }
                
            var noteData:Array = songData.notes;
            var daBeats:int = 0;
            
            for each(var section:Object in noteData)
            {
                var coolSection:int = int(section.lengthInSteps / 4);
                
                for each(var songNotes:Array in section.sectionNotes)
                {
                    var daStrumTime:Number = songNotes[0];
                    var daNoteData:int = int(songNotes[1] % 4);
                    
                    var gottaHitNote:Boolean = section.mustHitSection;
                    if (songNotes[1] > 3)
                        gottaHitNote = !section.mustHitSection;
                        
                    var oldNote:Note = unspawnNotes.length > 0 ? unspawnNotes[unspawnNotes.length - 1] : null;
                    
                    var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
                    swagNote.sustainLength = songNotes[2];
                    swagNote.scrollFactor = new Point(0, 0);
                    
                    var susLength:Number = swagNote.sustainLength;
                    susLength = susLength / Conductor.stepCrochet;
                    
                    unspawnNotes.push(swagNote);
                    
                    for (var susNote:int = 0; susNote < Math.floor(susLength); susNote++)
                    {
                        oldNote = unspawnNotes[unspawnNotes.length - 1];
                        
                        var sustainNote:Note = new Note(
                            daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet,
                            daNoteData, oldNote, true
                        );
                        sustainNote.scrollFactor = new Point(0, 0);
                        unspawnNotes.push(sustainNote);
                        
                        sustainNote.mustPress = gottaHitNote;
                        if (sustainNote.mustPress)
                            sustainNote.x += stage.stageWidth / 2;
                    }
                    
                    swagNote.mustPress = gottaHitNote;
                    if (swagNote.mustPress)
                        swagNote.x += stage.stageWidth / 2;
                }
                daBeats += 1;
            }
            
            unspawnNotes.sort(sortByTime);
            generatedMusic = true;
            startingSong = true;
            trace("generated song!" + generatedMusic);

            startSong();
        }
        
        private function sortByTime(a:Note, b:Note):Number
        {
            return a.strumTime - b.strumTime;
        }

        private function startSong():void
        {
            startingSong = false;
            songStarted = true;
            previousFrameTime = getTimer();
            
            inst = new Preloader.BopeeboInst();
            FunkinSound.playMusic(inst, 1, false);
            
            if (SONG.needsVoices)
            {
                vocals = new Preloader.BopeeboVoices();
                FunkinSound.play(vocals, 1);
            }
                
            Conductor.songPosition = 0;
        }

        override public function update(elapsed:Number):void
        {
            super.update(elapsed);

            if (!startingSong)
            {
                Conductor.songPosition += elapsed * 1000;

                if (!paused)
                {
                    songTime += getTimer() - previousFrameTime;
                    previousFrameTime = getTimer();

                    if (Conductor.lastSongPos != Conductor.songPosition)
                    {
                        songTime = (songTime + Conductor.songPosition) / 2;
                        Conductor.lastSongPos = Conductor.songPosition;
                    }
                }
            }

            if (generatedMusic)
            {
                for each (var currentNote:Note in notes.members) {
                    currentNote.y = (currentNote.strumTime - Conductor.songPosition) * (0.45 * SONG.speed);
                }

                var sortedNotes:Array = [];
                for each (var noteSprite:FunkinSprite in notes.members) {
                    sortedNotes.push(noteSprite);
                }
                sortedNotes.sort(sortByY);
                
                while (notes.numChildren > 0) {
                    notes.removeChildAt(0);
                }
                for each (var sortedNote:Note in sortedNotes) {
                    notes.addChild(sortedNote);
                }

                if (unspawnNotes[0] != null)
                {
                    var time:Number = 1500;

                    while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
                    {
                        var dunceNote:Note = unspawnNotes[0];
                        notes.add(dunceNote);

                        var index:int = unspawnNotes.indexOf(dunceNote);
                        unspawnNotes.splice(index, 1);
                    }
                }
            }
        }
        
        private function sortByY(obj1:FunkinSprite, obj2:FunkinSprite):Number
        {
            return obj1.y - obj2.y;
        }

        override public function beatHit():void
        {
            super.beatHit();

            if (generatedMusic)
            {
                var sortedNotes:Array = [];
                for each (var member:FunkinSprite in notes.members) {
                    sortedNotes.push(member);
                }
                sortedNotes.sort(sortByY);
                
                while (notes.numChildren > 0) {
                    notes.removeChildAt(0);
                }
                for each (var note:Note in sortedNotes) {
                    notes.addChild(note);
                }
            }
        }

        override public function destroy():void
        {
            super.destroy();
        }        
    }
} 