////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.filters
{
    import __AS3__.vec.Vector;
    
    import com.noteflight.standingwave2.elements.IAudioSource;
    import com.noteflight.standingwave2.elements.Sample;
    
    public class EchoFilter extends AbstractFilter
    {
        private var _bufferLength:Number;
        private var _wet:Number;
        private var _decay:Number;
        private var _ring:Sample;
        
        public function EchoFilter(source:IAudioSource, period:Number, wet:Number = 0.5, decay:Number = 0.5)
        {
            super(source);
            _wet = wet;
            _bufferLength = period * descriptor.rate;
            _decay = decay;
        }
        
        ////////////////////////////////////////////        
        // overrideable abstract methods
        ////////////////////////////////////////////

        override protected function transformChannel(data:Vector.<Number>, channel:Number, start:Number, numFrames:Number):void
        {
            if (_ring == null)
            {
                _ring = new Sample(descriptor, _bufferLength);
            }
            
            var j:Number = start % _bufferLength;
            var ringData:Vector.<Number> = _ring.channelData[channel];
            for (var i:Number = 0; i < numFrames; i++)
            {
                var echo:Number = ringData[j];
                ringData[j] = data[i] + (echo * _decay);
                j++;
                if (j >= ringData.length)
                {
                    j = 0;
                }
                data[i] += echo * _wet;
            }             
        }

        override public function clone():IAudioSource
        {
            return new EchoFilter(source.clone(), _bufferLength / descriptor.rate, _wet, _decay);
        }
    }
}
