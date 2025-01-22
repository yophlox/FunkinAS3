package engine
{
    import flash.geom.Rectangle;
    import flash.geom.Point;
    
    public class SparrowFrame
    {
        public var name:String;
        public var frame:Rectangle;
        public var rotated:Boolean;
        public var trimmed:Boolean;
        public var sourceSize:Point;
        public var offset:Point;
        
        public function SparrowFrame(Name:String, Frame:Rectangle, Rotated:Boolean, Trimmed:Boolean, SourceSize:Point, Offset:Point)
        {
            name = Name;
            frame = Frame;
            rotated = Rotated;
            trimmed = Trimmed;
            sourceSize = SourceSize;
            offset = Offset;
        }
    }
} 