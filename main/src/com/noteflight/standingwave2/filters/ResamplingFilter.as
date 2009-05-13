////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.filters
{
    import com.noteflight.standingwave2.elements.AudioDescriptor;
    import com.noteflight.standingwave2.elements.IAudioSource;
    import com.noteflight.standingwave2.elements.IRandomAccessSource;
    import com.noteflight.standingwave2.elements.Sample;
    import com.noteflight.standingwave2.utils.AudioUtils;
    
    /**
     * This filter implementation resamples an input source by interpolating its samples
     * using a sampling frequency that is some factor higher or lower than its actual
     * sample rate. 
     */
    public class ResamplingFilter implements IAudioSource, IRandomAccessSource
    {
        /**
         * The factor by which the source's frequency is to be resampled.  Higher factors
         * shift frequency upwards.
         */
        public var factor:Number;

        /** The position of this filter */
        private var _position:Number;
        
        /** A cache for the underlying source */
        private var _sourceCache:IRandomAccessSource;
        
        /** The underlying source */
        private var _source:IAudioSource;

        /**
         * Create a new ResamplingFilter to adjust the frequency of its input. 
         * 
         * @param source the input source for this filter
         * @param factor the factor by which the input frequency should be multiplied.
         */        
        public function ResamplingFilter(source:IAudioSource = null, factor:Number = 1)
        {
            this.factor = factor;
            this.source = source;
        }
        
        /**
         * The underlying audio source for this filter. 
         */
        public function get source():IAudioSource
        {
            return _source;
        }
        
        public function set source(s:IAudioSource):void
        {
            if (s != null)
            {
                _source = s;
                _sourceCache = AudioUtils.toRandomAccessSource(s);
                resetPosition();
            }
            else
            {
                _source = null;
                _sourceCache = null;
            }            
        }

        /**
         * Get the AudioDescriptor for this Sample.
         */
        public function get descriptor():AudioDescriptor
        {
            return _source.descriptor;
        }
        
        /**
         * Get the number of sample frames in this AudioSource.
         */
        public function get frameCount():Number
        {
            return Math.floor((_source.frameCount - 1) / factor) + 1;
        }
        
        public function get position():Number
        {
            return _position;
        }
        
        public function resetPosition():void
        {
            _position = 0;
        }
        
        /**
         * Get the concrete audio data from this source that occurs within a given time interval.
         * The interval must lie within the bounds of the length of the Sample.
         * 
         * @param fromOffset the inclusive start of the interval, in sample frames.
         * @param toOffset the exclusive end of the interval (that is, one past the last sample frame in the interval)
         * @return a Sample representing the data in the interval.
         */
        public function getSampleRange(fromOffset:Number, toOffset:Number):Sample
        {
            if (factor == 1)
            {
                // not likely, but optimize case where there is no frequency shift
                return _sourceCache.getSampleRange(fromOffset, toOffset);
            }

            // Create the result sample in which the frequency-shifted data will go.
            var sample:Sample = new Sample(descriptor, toOffset - fromOffset);

            // Cache some things we'll need
            var srcStart:Number = Math.floor(fromOffset * factor);
            var srcEnd:Number = Math.ceil((toOffset-1) * factor) + 1;
            var channelData:Array = _sourceCache.getSampleRange(srcStart, srcEnd).channelData;

            // Resample each channel of the input by walking through it using a
            // fractional frame increment on the source, and an increment of 1 on
            // the destination data.  If the source increment is 1 (no shift), the
            // data would be merely copied, but it is fractional and so interpolation
            // takes place.
            //
            for (var c:uint = 0; c < descriptor.channels; c++)
            {
                var data:Vector.<Number> = channelData[c];
                var destData:Vector.<Number> = sample.channelData[c];
                var destFrame:int = fromOffset;
                var destIndex:uint = 0;
                var srcFrame:Number;
                var intPos:uint;
                var fracPos:Number;
                var srcIndex:uint;
            
                while (destFrame < toOffset)
                {
                    // Determine integral and fractional frame index,
                    // plus the source sample index for the first channel.
                    srcFrame = (destFrame * factor) - srcStart;
                    intPos = int(srcFrame);
                    fracPos = srcFrame - intPos;
                    srcIndex = intPos;

                    var s1:Number = data[srcIndex++];
                    if (fracPos > 0)
                    {
                        var s2:Number = data[srcIndex];
                        destData[destIndex++] = s1 + (fracPos * (s2 - s1));
                    }
                    else
                    {
                        destData[destIndex++] = s1;
                    }
                    destFrame++;
                }
            }
            return sample;
        }

        public function getSample(numFrames:Number):Sample
        {
            var sample:Sample = getSampleRange(_position, _position + numFrames);
            _position += numFrames;
            return sample;
        }
        
        public function clone():IAudioSource
        {
            return new ResamplingFilter(_source.clone(), factor);
        }
    }
}
