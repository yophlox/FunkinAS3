package engine
{
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.events.Event;
    
    public class FunkinSound
    {
        private static var _musicChannel:SoundChannel;
        private static var _currentMusic:Sound;
        private static var _transform:SoundTransform;
        private static var _sfxTransform:SoundTransform;
        
        {
            _transform = new SoundTransform(1);
            _sfxTransform = new SoundTransform(1);
        }
        
        public static function playMusic(sound:Sound, volume:Number = 1, looped:Boolean = true):void
        {
            if (_musicChannel != null)
            {
                _musicChannel.stop();
            }
            
            _currentMusic = sound;
            _transform.volume = volume;
            _musicChannel = _currentMusic.play(0, looped ? int.MAX_VALUE : 0, _transform);
        }
        
        public static function play(sound:Sound, volume:Number = 1):void
        {
            _sfxTransform.volume = volume;
            sound.play(0, 0, _sfxTransform);
        }
        
        public static function stopMusic():void
        {
            if (_musicChannel != null)
            {
                _musicChannel.stop();
                _musicChannel = null;
            }
        }
        
        public static function set volume(value:Number):void
        {
            _transform.volume = value;
            if (_musicChannel != null)
            {
                _musicChannel.soundTransform = _transform;
            }
        }
        
        public static function get volume():Number
        {
            return _transform.volume;
        }
        
        public static function stop(sound:Sound):void
        {
            if (sound)
            {
                try {
                    stopMusic();
                } catch (e:Error) {
                    trace("Error stopping sound: " + e.message);
                }
            }
        }
    }
}