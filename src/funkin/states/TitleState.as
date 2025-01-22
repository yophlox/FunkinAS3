package funkin.states
{
    import funkin.MusicBeatState;
    import engine.FunkinSprite;
    import flash.display.Bitmap;
    import engine.FunkinTimer;
    import funkin.game.Conductor;
    
    public class TitleState extends MusicBeatState
    {
        // spritesheets and xmls (embed shit basically)
        [Embed(source="../../../assets/images/gfDanceTitle.png")]
        private static const GfImage:Class;
        
        [Embed(source="../../../assets/images/gfDanceTitle.xml", mimeType="application/octet-stream")]
        private static const GfXml:Class;

        [Embed(source="../../../assets/images/logoBumpin.png")]
        private static const LogoImage:Class;
        
        [Embed(source="../../../assets/images/logoBumpin.xml", mimeType="application/octet-stream")]
        private static const LogoXml:Class;

        // variables
        private var initialized:Boolean = false;
        private var gfDance:FunkinSprite;
        private var logoBl:FunkinSprite;
        
        override public function create():void
        {
            super.create();

            new FunkinTimer(1).start(1, function(tmr:FunkinTimer):void {
                startIntro();
            });
        }

        private function startIntro():void
        {
            trace("TitleState: Starting intro...");
            Conductor.changeBPM(102);

            logoBl = new FunkinSprite(-150, -100);
            var bitmapLogo:Bitmap = new LogoImage();
            var xmlLogo:XML = new XML(new LogoXml());
            
            logoBl.loadSparrowAtlas(bitmapLogo, xmlLogo);
            logoBl.animation_addByPrefix('bump', 'logo bumpin', 24, true);
            logoBl.animation_play('bump');
            logoBl.graphic.smoothing = true;
            add(logoBl);

            gfDance = new FunkinSprite(stage.stageWidth * 0.4, stage.stageHeight * 0.07);
            var bitmap:Bitmap = new GfImage();
            var xml:XML = new XML(new GfXml());
            
            gfDance.loadSparrowAtlas(bitmap, xml);
            gfDance.animation_addByIndices('danceLeft', 'gfDance', 
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 
                "", 24, false);
            gfDance.animation_addByIndices('danceRight', 'gfDance', 
                [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 
                "", 24, false);
            gfDance.graphic.smoothing = true;
            gfDance.animation_play('danceLeft');
            add(gfDance);
        }
        
        override public function update(elapsed:Number):void
        {
            if (gfDance != null) gfDance.update(elapsed);
            if (logoBl != null) logoBl.update(elapsed);
            super.update(elapsed);
        }
    }
} 