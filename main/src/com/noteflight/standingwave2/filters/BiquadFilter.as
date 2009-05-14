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
    
    public class BiquadFilter extends AbstractFilter
    {
        private var _frequency:Number;
        private var _resonance:Number;
        private var _type:int;
        private var _state:Array = null;
        private var _a0:Number, _a1:Number, _a2:Number; 
        private var _b0:Number, _b1:Number, _b2:Number; 
        
        public static const LOW_PASS_TYPE:int = 0;
        public static const HIGH_PASS_TYPE:int = 1;
        public static const BAND_PASS_TYPE:int = 2;
        
        public function BiquadFilter(source:IAudioSource = null, type:int = LOW_PASS_TYPE, frequency:Number = 1000, resonance:Number = 1)
        {
            super(source);
            this.type = type;
            this.frequency = frequency;
            this.resonance = resonance;
        }

        override public function resetPosition():void
        {
            super.resetPosition();
            initializeState();
        }        
        
        public function get type():int
        {
            return _type;
        }
        
        public function set type(value:int):void
        {
            _type = value;
            initializeState();
        }
        
        public function get frequency():Number
        {
            return _frequency;
        }
        
        public function set frequency(value:Number):void
        {
            _frequency = value;
            initializeState();
        }
        
        public function get resonance():Number
        {
            return _resonance;
        }
        
        public function set resonance(value:Number):void
        {
            _resonance = value;
            initializeState();
        }
        
        protected function initializeState():void
        {
            _state = null;
        }
        
        protected function computeState():void
        {
            if (_state != null)
            {
                return;
            }
            
            // Initialize delay line state per channel
            _state = [];
            for (var i:int = 0; i < descriptor.channels; i++)
            {
                _state[i] = [ 0, 0, 0, 0 ];
            }
            
            // Set up filter coefficients.
            // Formulae courtesy of http://www.musicdsp.org/files/Audio-EQ-Cookbook.txt
            //
            var w0:Number = 2 * Math.PI * _frequency / descriptor.rate;
            var cosw0:Number = Math.cos(w0);
            var sinw0:Number = Math.sin(w0);
            var alpha:Number = sinw0 / (2 * _resonance);
            
            switch (_type)
            {
                case LOW_PASS_TYPE:
                    _b0 = (1 - cosw0) / 2;
                    _b1 = 1 - cosw0;
                    _b2 = (1 - cosw0) / 2
                    _a0 = 1 + alpha;
                    _a1 = -2 * cosw0;
                    _a2 = 1 - alpha;
                    break;
                    
                case HIGH_PASS_TYPE:
                    _b0 = (1 + cosw0) / 2;
                    _b1 = -(1 + cosw0);
                    _b2 = (1 + cosw0) / 2;
                    _a0 = 1 + alpha;
                    _a1 = -2 * cosw0;
                    _a2 = 1 - alpha;
                    break;
                    
                case BAND_PASS_TYPE:
                    _b0 = alpha;
                    _b1 = 0;
                    _b2 = -alpha;
                    _a0 = 1 + alpha;
                    _a1 = -2 * cosw0;
                    _a2 = 1 - alpha;
                    break;
            }
            
            // Normalization step for coefficients other than a0
            _b0 /= _a0;
            _b1 /= _a0;
            _b2 /= _a0;
            _a1 /= _a0;
            _a2 /= _a0;
        }
        
        ////////////////////////////////////////////        
        // overrideable abstract methods
        ////////////////////////////////////////////

        override protected function transformChannel(data:Vector.<Number>, channel:Number, start:Number, numFrames:Number):void
        {
            computeState();
            
            var channelState:Array = _state[channel];
            var x1:Number = channelState[0];
            var x2:Number = channelState[1];
            var y1:Number = channelState[2];
            var y2:Number = channelState[3];
            
            for (var i:Number = 0; i < numFrames; i++)
            {
                var x:Number = data[i];
                var y:Number = x*_b0 + x1*_b1 + x2*_b2 - y1*_a1 - y2*_a2;
                x2 = x1;
                x1 = x;
                y2 = y1;
                data[i] = y1 = y;
            }

            channelState[0] = x1;
            channelState[1] = x2;
            channelState[2] = y1;
            channelState[3] = y2;                 
        }

        override public function clone():IAudioSource
        {
            return new BiquadFilter(source.clone(), type, frequency, resonance);
        }
    }
}
