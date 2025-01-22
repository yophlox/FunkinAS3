package funkin.states
{
    import funkin.MusicBeatState;
    import engine.FunkinSprite;
    import flash.display.Bitmap;
    import engine.FunkinTimer;
    import engine.FunkinSound;
    import funkin.game.Conductor;
    import flash.ui.Keyboard;
    import engine.StateManager;
    import funkin.states.PlayState;
    import engine.FunkinInput;
    import Preloader;

    public class TitleState extends MusicBeatState
    {
        private var initialized:Boolean = false;
        private var gfDance:FunkinSprite;
        private var logoBl:FunkinSprite;
        private var titleEnter:FunkinSprite;
        private var danceLeft:Boolean = false;
        private var skippedIntro:Boolean = false;
        
        override public function create():void
        {
            trace("TitleState: Creating...");
            super.create();

            new FunkinTimer(1).start(1, function(tmr:FunkinTimer):void {
                startIntro();
            });
        }

        private function startIntro():void
        {
            trace("TitleState: Starting intro...");
            if (!initialized)
            {
                FunkinSound.playMusic(new Preloader.MenuMusic(), 0);
                initialized = true;
            }
            Conductor.changeBPM(102);

            logoBl = new FunkinSprite(-150, -100);
            var bitmapLogo:Bitmap = new Preloader.LogoBumpImage();
            var xmlLogo:XML = new XML(new Preloader.LogoBumpXml());
            
            logoBl.loadSparrowAtlas(bitmapLogo, xmlLogo);
            logoBl.animation_addByPrefix('bump', 'logo bumpin', 24, true);
            logoBl.animation_play('bump');
            logoBl.graphic.smoothing = true;

            gfDance = new FunkinSprite(stage.stageWidth * 0.4, stage.stageHeight * 0.07);
            var bitmap:Bitmap = new Preloader.GfImage();
            var xml:XML = new XML(new Preloader.GfXml());
            
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
            add(logoBl);

            titleEnter = new FunkinSprite(100, stage.stageHeight * 0.8);
            var bitmapTitleEnter:Bitmap = new Preloader.TitleEnterImage();
            var xmlTitleEnter:XML = new XML(new Preloader.TitleEnterXml());
            
            titleEnter.loadSparrowAtlas(bitmapTitleEnter, xmlTitleEnter);
            titleEnter.animation_addByPrefix('idle', 'Press Enter to Begin', 24, true);
            titleEnter.animation_addByPrefix('press', 'ENTER PRESSED', 24, false);
            titleEnter.graphic.smoothing = true;
            titleEnter.animation_play('idle', false, true);
            add(titleEnter);
        }
        
        override public function update(elapsed:Number):void
        {            
            if (FunkinInput.justPressed(Keyboard.ENTER))
            {
                trace("TitleState: Enter key pressed!");
                titleEnter.animation_play('press', false, true);
                FunkinSound.play(new Preloader.ConfirmMenu(), 0.7);
                new FunkinTimer(2).start(2, function(tmr:FunkinTimer):void {
                    FunkinSound.stopMusic();
                    StateManager.Instance.switchState(PlayState);
                });
            }

            if (FunkinSound.volume < 1)
            {
                FunkinSound.volume += elapsed * 0.5;
            }

            if (gfDance != null) gfDance.update(elapsed);
            if (logoBl != null) logoBl.update(elapsed);
            if (titleEnter != null) titleEnter.update(elapsed);
            super.update(elapsed);
        }

        override public function beatHit():void
        {
            super.beatHit();
            
            if (logoBl != null)
                logoBl.animation_play('bump');
                
            if (gfDance != null)
            {
                danceLeft = !danceLeft;
                if (danceLeft)
                    gfDance.animation_play('danceRight');
                else
                    gfDance.animation_play('danceLeft');
            }
        }

        override public function destroy():void
        {
            if (gfDance != null) {
                gfDance.destroy();
                gfDance = null;
            }
            
            if (logoBl != null) {
                logoBl.destroy();
                logoBl = null;
            }
            
            if (titleEnter != null) {
                titleEnter.destroy();
                titleEnter = null;
            }
                        
            super.destroy();
        }
    }
} 