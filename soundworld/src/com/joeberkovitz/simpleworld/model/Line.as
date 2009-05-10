package com.joeberkovitz.simpleworld.model
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
        
    /**
     * Value object representing a Line in the world. 
     */
    [RemoteClass]
    public class Line extends WorldShape
    {
        [Bindable]
        public var width:Number = 0;
        
        [Bindable]
        public var height:Number = 0;
        
        public function get p1():Point
        {
            return new Point(x, y);
        }
        
        public function set p1(p:Point):void
        {
            width -= p.x - x;
            height -= p.y - y;
            x = p.x;
            y = p.y;
        }
        
        public function get p2():Point
        {
            return new Point(x + width, y + height);
        }
        
        public function set p2(p:Point):void
        {
            width = p.x - x;
            height = p.y - y;
        }
        
        override public function get bounds():Rectangle
        {
            return new Rectangle(Math.min(x, x + width), Math.min(y, y + height),
                                 Math.abs(width), Math.abs(height));
        }
     }
}
