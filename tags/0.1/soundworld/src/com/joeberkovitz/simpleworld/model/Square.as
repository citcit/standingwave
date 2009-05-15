package com.joeberkovitz.simpleworld.model
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
        
    /**
     * Value object representing a Square in the world. 
     */
    [RemoteClass]
    public class Square extends WorldShape
    {
        [Bindable]
        public var size:Number;
        
        [Bindable]
        public var angle:Number = 0;
 
        public function get cornerX():Number
        {
            return x + (size/2) * Math.cos(angle + Math.PI/4) * Math.SQRT2; 
        }
        
        public function get cornerY():Number
        {
            return y + (size/2) * Math.sin(angle + Math.PI/4) * Math.SQRT2; 
        }
        
        public function get corner():Point
        {
            return new Point(cornerX, cornerY);
        }
        
        public function set corner(p:Point):void
        {
            size = 2 * Point.distance(p, new Point(x, y)) * Math.SQRT1_2;
        }
 
        override public function get bounds():Rectangle
        {
            return new Rectangle(x, y, size, size);
        }
     }
}
