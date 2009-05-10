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
    import com.noteflight.standingwave2.elements.Sample;
    
    /**
     * An abstract implementation of the IAudioFilter interface that can be
     * overridden to supply the specific transformation for a specific filter subclass. 
     */
    public class AbstractFilter implements IAudioFilter
    {
        // the source for this filter        
        protected var _source:IAudioSource;
        
        /**
         * Create a new filter based on some underlying source. 
         * @param source the source that this filter transforms to produce its output.
         */
        public function AbstractFilter(source:IAudioSource = null)
        {
            this.source = source;
        }
        
        ////////////////////////////////////////////        
        // overrideable abstract methods
        ////////////////////////////////////////////

        protected function transformChannel(data:Vector.<Number>, channel:Number, start:Number, numFrames:Number):void
        {
            throw new Error("generateChannel() not overridden");
        }

        ////////////////////////////////////////////        
        // IAudioFilter interface implementation
        ////////////////////////////////////////////        
        
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
            return _source.position;
        }
        
        public function resetPosition():void
        {
            _source.resetPosition();
        }
        
        /**
         * @inheritDoc
         */
        public function getSample(numFrames:Number):Sample
        {
            var startPos:Number = position;
            var sample:Sample = _source.getSample(numFrames);
            for (var c:Number = 0; c < sample.channels; c++)
            {
                transformChannel(sample.channelData[c], c, startPos, numFrames);
            }
            return sample;
        }

        public function clone():IAudioSource
        {
            throw new Error("clone() not overridden");
        }
    }
}
