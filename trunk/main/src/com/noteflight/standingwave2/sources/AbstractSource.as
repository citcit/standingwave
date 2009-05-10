////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.sources
{
    import __AS3__.vec.Vector;
    
    import com.noteflight.standingwave2.elements.AudioDescriptor;
    import com.noteflight.standingwave2.elements.IAudioSource;
    import com.noteflight.standingwave2.elements.Sample;
    
    public class AbstractSource implements IAudioSource
    {
        /** Audio descriptor for this source. */
        protected var _descriptor:AudioDescriptor;
        protected var _position:Number;

        public var amplitude:Number;
        public var duration:Number;
        
        public static const MAX_DURATION:Number = 100000.0;

        public function AbstractSource(descriptor:AudioDescriptor, duration:Number = MAX_DURATION, amplitude:Number = 1.0)
        {
            _descriptor = descriptor;
            this.amplitude = amplitude;
            this.duration = duration;
            _position = 0;
        }
        
        protected function generateChannel(data:Vector.<Number>, channel:Number, numFrames:Number):void
        {
            throw new Error("generateChannel() not overridden");
        }

        ////////////////////////////////////////////        
        // IAudioSource interface implementation
        ////////////////////////////////////////////        
        
        /**
         * Get the AudioDescriptor for this Sample.
         */
        public function get descriptor():AudioDescriptor
        {
            return _descriptor;
        }
        
        public function get frameCount():Number
        {
            return Math.floor(duration * _descriptor.rate);
        }

        public function get position():Number
        {
            return _position;
        }
        
        public function resetPosition():void
        {
            _position = 0;
        }
        
        public function getSample(numFrames:Number):Sample
        {
            var sample:Sample = new Sample(descriptor, numFrames);
            for (var c:Number = 0; c < descriptor.channels; c++)
            {
                var data:Vector.<Number> = new Vector.<Number>(numFrames, true); 
                sample.channelData[c] = data;
                generateChannel(data, c, numFrames);
            }
            _position += numFrames;
            
            return sample;
        }
        
        public function clone():IAudioSource
        {
            throw new Error("clone() not overridden");
        }
    }
}
