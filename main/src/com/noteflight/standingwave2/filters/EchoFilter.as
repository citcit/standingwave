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
        private var _period:Number;
        private var _ring:Sample;
        
        public function EchoFilter(source:IAudioSource = null, period:Number = 0, wet:Number = 0.5, decay:Number = 0.5)
        {
            super(source);
            this.period = period;
            this.wet = wet;
            this.decay = decay;
        }
        
        override public function resetPosition():void
        {
            super.resetPosition();
            initializeState();
        }        
        
        public function get wet():Number
        {
            return _wet;
        }
        
        public function set wet(value:Number):void
        {
            _wet = value;
            initializeState();
        }
        
        public function get decay():Number
        {
            return _decay;
        }
        
        public function set decay(value:Number):void
        {
            _decay = value;
            initializeState();
        }
        
        public function get period():Number
        {
            return _period;
        }
        
        public function set period(value:Number):void
        {
            _period = value;
            initializeState();
        }
        
        protected function initializeState():void
        {
            _ring = null;
        }
        
        ////////////////////////////////////////////        
        // overrideable abstract methods
        ////////////////////////////////////////////

        override protected function transformChannel(data:Vector.<Number>, channel:Number, start:Number, numFrames:Number):void
        {
            if (_ring == null)
            {
                _bufferLength = Math.floor(_period * descriptor.rate);
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
            return new EchoFilter(source.clone(), period, wet, decay);
        }
    }
}
