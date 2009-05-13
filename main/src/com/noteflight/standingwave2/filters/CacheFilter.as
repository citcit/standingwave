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
    import com.noteflight.standingwave2.elements.IAudioFilter;
    import com.noteflight.standingwave2.elements.IAudioSource;
    import com.noteflight.standingwave2.elements.IRandomAccessSource;
    import com.noteflight.standingwave2.elements.Sample;
    
    /**
     * This audio filter does not transform its underlying source.  It merely caches its
     * audio data in a stored Sample object, which is expanded dynamically to cover a range
     * from the first frame up to the last frame requested via a call to getSample().
     */
    public class CacheFilter implements IAudioFilter, IRandomAccessSource
    {
        private var _cache:Sample;
        private var _position:Number;
        private var _source:IAudioSource;
        
        public function CacheFilter(source:IAudioSource = null)
        {
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
            _source = s;
            if (_source != null)
            {
                // reset our cached data if the source changes
                _cache = new Sample(source.descriptor, 0);
                _source.resetPosition();  // index after last frame read into cache

                resetPosition();
            }            
        }

        /**
         * Get the AudioDescriptor for this Sample.
         */
        public function get descriptor():AudioDescriptor
        {
            return source.descriptor;
        }
        
        /**
         * @inheritDoc
         */
        public function get frameCount():Number
        {
            return source.frameCount;
        }
        
        /**
         * @inheritDoc
         */
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
         * The interval must lie within the bounds of the length of the underlying source.
         * 
         * @param fromOffset the inclusive start of the interval, in sample frames.
         * @param toOffset the exclusive end of the interval (that is, one past the last sample frame in the interval)
         * @return a Sample representing the data in the interval.
         */
        public function getSampleRange(fromOffset:Number, toOffset:Number):Sample
        {
            if (toOffset > source.position)
            {
                // An uncached run of data is being retrieved; add it to the cache by calling
                // getSample() on the source and copying that into the cache.
                //
                var sample:Sample = source.getSample(toOffset - source.position);
                for (var c:int = 0; c < sample.channels; c++)
                {
                    _cache.channelData[c] = Vector.<Number>(_cache.channelData[c]).concat(sample.channelData[c]);
                }
            }
            return _cache.getSampleRange(fromOffset, toOffset);
        }
         
        public function getSample(numFrames:Number):Sample
        {
            var sample:Sample = getSampleRange(_position, _position + numFrames);
            _position += numFrames;
            return sample;
        }
        
        public function clone():IAudioSource
        {
            return new CacheFilter(source.clone());
        }
    }
}
