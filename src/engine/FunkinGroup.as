package engine
{
    import flash.display.Sprite;
    
    public class FunkinGroup extends Sprite
    {
        protected var _members:Vector.<FunkinSprite>;
        protected var _length:int;
        
        public function FunkinGroup()
        {
            super();
            _members = new Vector.<FunkinSprite>();
            _length = 0;
        }
        
        public function add(Sprite:FunkinSprite):FunkinSprite
        {
            if (Sprite == null)
                return null;
                
            _members[_length++] = Sprite;
            addChild(Sprite);
            return Sprite;
        }
        
        public function remove(Sprite:FunkinSprite, Splice:Boolean = false):FunkinSprite
        {
            var index:int = _members.indexOf(Sprite);
            if (index < 0)
                return null;
                
            if (contains(Sprite))
                removeChild(Sprite);
                
            if (Splice)
            {
                _members.splice(index, 1);
                _length--;
            }
            else
                _members[index] = null;
                
            return Sprite;
        }
        
        public function forEach(Function:Function):void
        {
            for (var i:int = 0; i < _length; i++)
            {
                if (_members[i] != null)
                    Function(_members[i]);
            }
        }
        
        public function clear():void
        {
            forEach(function(sprite:FunkinSprite):void {
                remove(sprite, true);
            });
            _members.length = 0;
            _length = 0;
        }
        
        public function get members():Vector.<FunkinSprite>
        {
            return _members;
        }
        
        public function get length():int
        {
            return _length;
        }
    }
}