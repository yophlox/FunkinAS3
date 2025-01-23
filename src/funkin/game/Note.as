package funkin.game
{
    import engine.FunkinSprite;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import funkin.game.Conductor;
    import funkin.states.PlayState;
    
    public class Note extends FunkinSprite
    {
        [Embed(source="../../../assets/images/NOTE_assets.png")]
        private static const NoteAssets:Class;

        [Embed(source="../../../assets/images/NOTE_assets.xml", mimeType="application/octet-stream")]
        private static const NoteAssetsXML:Class;
        
        public var strumTime:Number = 0;
        public var mustPress:Boolean = false;
        public var noteData:int = 0;
        public var canBeHit:Boolean = false;
        public var tooLate:Boolean = false;
        public var wasGoodHit:Boolean = false;
        public var prevNote:Note;
        
        public var sustainLength:Number = 0;
        public var isSustainNote:Boolean = false;
        public var noteScore:Number = 1;
        
        public static var swagWidth:Number = 125;
        public static const PURP_NOTE:int = 0;
        public static const GREEN_NOTE:int = 2;
        public static const BLUE_NOTE:int = 1;
        public static const RED_NOTE:int = 3;
        
        public function Note(strumTime:Number, noteData:int, prevNote:Note = null, sustainNote:Boolean = false)
        {
            super();
            
            if (prevNote == null)
                prevNote = this;
            
            this.prevNote = prevNote;
            this.isSustainNote = sustainNote;
            
            x += 50;
            y -= 2000;
            this.strumTime = strumTime;
            this.noteData = noteData;
            
            var bitmap:Bitmap = new NoteAssets();
            var xml:XML = new XML(new NoteAssetsXML());
            loadSparrowAtlas(bitmap, xml);
            
            animation_addByPrefix('greenScroll', 'green0');
            animation_addByPrefix('redScroll', 'red0');
            animation_addByPrefix('blueScroll', 'blue0');
            animation_addByPrefix('purpleScroll', 'purple0');
            
            animation_addByPrefix('purpleholdend', 'pruple end hold');
            animation_addByPrefix('greenholdend', 'green hold end');
            animation_addByPrefix('redholdend', 'red hold end');
            animation_addByPrefix('blueholdend', 'blue hold end');
            
            animation_addByPrefix('purplehold', 'purple hold piece');
            animation_addByPrefix('greenhold', 'green hold piece');
            animation_addByPrefix('redhold', 'red hold piece');
            animation_addByPrefix('bluehold', 'blue hold piece');
            
            setGraphicSize(Math.floor(width * 0.7));
            updateHitbox();
            scale.set(0.8, 0.8);
            updateHitbox();
            
            switch (noteData)
            {
                case 0:
                    x += swagWidth * 0;
                    animation_play('purpleScroll');
                    break;
                case 1:
                    x += swagWidth * 1;
                    animation_play('blueScroll');
                    break;
                case 2:
                    x += swagWidth * 2;
                    animation_play('greenScroll');
                    break;
                case 3:
                    x += swagWidth * 3;
                    animation_play('redScroll');
                    break;
            }
            
            if (isSustainNote && prevNote != null)
            {
                noteScore *= 0.2;
                alpha = 0.6;
                x += width / 2;
                
                switch (noteData)
                {
                    case 2:
                        animation_play('greenholdend');
                        break;
                    case 3:
                        animation_play('redholdend');
                        break;
                    case 1:
                        animation_play('blueholdend');
                        break;
                    case 0:
                        animation_play('purpleholdend');
                        break;
                }
                
                updateHitbox();
                x -= width / 2;
                
                if (prevNote.isSustainNote)
                {
                    switch (prevNote.noteData)
                    {
                        case 0:
                            prevNote.animation_play('purplehold');
                            break;
                        case 1:
                            prevNote.animation_play('bluehold');
                            break;
                        case 2:
                            prevNote.animation_play('greenhold');
                            break;
                        case 3:
                            prevNote.animation_play('redhold');
                            break;
                    }
                    
                    prevNote.scale.set(prevNote.scale.x, (Conductor.stepCrochet / 100) * 1.5 * PlayState.SONG.speed);
                    prevNote.updateHitbox();
                }
            }
        }
        
        override public function update(elapsed:Number):void
        {
            super.update(elapsed);
            
            if (mustPress)
            {
                if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
                    && strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
                {
                    canBeHit = true;
                }
                else
                    canBeHit = false;
                
                if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset)
                    tooLate = true;
            }
            else
            {
                canBeHit = false;
                if (strumTime <= Conductor.songPosition)
                    wasGoodHit = true;
            }
            
            if (tooLate && alpha > 0.3)
                alpha = 0.3;
        }
    }
}
