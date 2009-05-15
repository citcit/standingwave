package com.joeberkovitz.simpleworld.model
{
    import flash.geom.Rectangle;
    
    /**
     * Abstract value object representing some shape in the world.
     */
    [RemoteClass]
    public class WorldShape
    {
        [Bindable]
        public var color:uint;
        
        [Bindable]
        public var x:Number = 0;

        [Bindable]
        public var y:Number = 0;
        
        public function get bounds():Rectangle
        {
            throw new Error("bounds() not overridden");
        }
    }
}