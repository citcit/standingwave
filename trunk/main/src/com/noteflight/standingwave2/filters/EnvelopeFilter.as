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
    import com.noteflight.standingwave2.utils.AudioUtils;
    
    public class EnvelopeFilter extends AbstractFilter
    {
        /** The duration of the attack envelope in frames. */
        public var attack:Number;
        
        /** The duration of the decay envelope in frames. */
        public var decay:Number;
        
        /** The sustain level of the envelope, expressed as a multiplying factor. */
        public var sustain:Number;
        
        /** The duration of the hold phase of the element in frames. */
        public var hold:Number;
        
        /** The release duration for the envelope, in frames. */
        public var release:Number;
        
        /** current gain */
        private var _currentGain:Number = 0;
        
        public function EnvelopeFilter(source:IAudioSource, attackTime:Number, decayTime:Number, sustain:Number, holdTime:Number, releaseTime:Number)
        {
            super(source);
            this.attack = Math.floor(attackTime * source.descriptor.rate);
            this.decay = Math.floor(decayTime * source.descriptor.rate);
            this.sustain = sustain;
            this.hold = Math.floor(holdTime * source.descriptor.rate);
            this.release = Math.floor(releaseTime * source.descriptor.rate);
        }
                
        /**
         * Return the length of this source.
         */
        override public function get frameCount():Number
        {
            return Math.min(super.frameCount, attack + decay + hold + release);
        }

        override public function resetPosition():void
        {
            super.resetPosition();
            if (attack == 0)
            {
                if (decay == 0)
                {
                    _currentGain = sustain;
                }
                else
                {
                    _currentGain = 1;
                }
            }
            else
            {
                _currentGain = 0;
            }
        }
        
        override public function getSample(numFrames:Number):Sample
        {
            var startPos:Number = position;
            var sample:Sample = _source.getSample(numFrames);
            var startGain:Number = _currentGain;
            
            for (var c:Number = 0; c < sample.channels; c++)
            {
                _currentGain = startGain;
                var data:Vector.<Number> = sample.channelData[c];
                var index:Number = 0;
                var i:Number = startPos;
                var endOffset:Number = startPos + numFrames;
            
                var phaseEnd:Number = Math.min(endOffset, attack);
                var attackLevel:Number = (decay > 0) ? 1.0 : sustain;
                var attackIncrement:Number = attackLevel / attack;
                while (i < phaseEnd)
                {
                    data[index++] *= _currentGain;
                    i++;
                    _currentGain += attackIncrement;
                }
            
                phaseEnd = Math.min(endOffset, phaseEnd + decay);
                var decayFactor:Number = Math.exp(Math.log(sustain) / decay);
                while (i < phaseEnd)
                {
                    data[index++] *= _currentGain;
                    i++;
                    _currentGain *= decayFactor;
                }

                phaseEnd = Math.min(endOffset, phaseEnd + hold);
                if (sustain < 1.0)
                {
                    while (i < phaseEnd)
                    {
                        data[index++] *= _currentGain;
                        i++;
                    }
                }
                else if (i < phaseEnd)
                {
                    index += phaseEnd - i;
                    i = phaseEnd;
                }

                phaseEnd = Math.min(endOffset, phaseEnd + release);
                var releaseFactor:Number = Math.exp(Math.log(AudioUtils.MINIMUM_SIGNAL / sustain) / release);
                while (i < phaseEnd)
                {
                    data[index++] *= _currentGain;
                    i++;
                    _currentGain *= releaseFactor;
                }
            }

            return sample;
        }

        override public function clone():IAudioSource
        {
            return new EnvelopeFilter(source.clone(), attack / descriptor.rate, decay / descriptor.rate, sustain, hold / descriptor.rate, release / descriptor.rate);
        }
    }
}