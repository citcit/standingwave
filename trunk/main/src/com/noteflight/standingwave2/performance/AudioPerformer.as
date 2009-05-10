////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.performance
{
    import __AS3__.vec.Vector;
    
    import com.noteflight.standingwave2.elements.AudioDescriptor;
    import com.noteflight.standingwave2.elements.IAudioSource;
    import com.noteflight.standingwave2.elements.Sample;
    
    /**
     * An AudioPerformer takes a Performance whose elements consist entirely of
     * PerformableAudioSources (i.e. timed playbacks of audio sources) and exposes
     * it as an IAudioSource that can realize time samples of the performance output,
     * mixing together all the performance elements with the correct time offsets.
     */
    public class AudioPerformer implements IAudioSource
    {
        private var _performance:IPerformance;
        private var _position:Number = 0;
        private var _frameCount:Number = 0;
        private var _activeElements:Vector.<PerformanceElement>;
                
        public function AudioPerformer(performance:IPerformance)
        {
            _performance = performance;
            _frameCount = performance.frameCount;
            resetPosition();
        }
        
        public function get duration():Number
        {
            return frameCount / descriptor.rate;
        }
        
        public function set duration(value:Number):void
        {
            frameCount = Math.floor(value * descriptor.rate);
        }
        
        /**
         * The AudioDescriptor describing the audio characteristics of this source.
         */
        public function get descriptor():AudioDescriptor
        {
            return _performance.descriptor;
        }
        
        /**
         * Return the number of sample frames in this source.
         */
        public function get frameCount():Number
        {
            return _frameCount;
        }
        
        public function set frameCount(value:Number):void
        {
            _frameCount = value;
        }
        
        public function get position():Number
        {
            return _position;
        }
        
        public function resetPosition():void
        {
            _position = 0;
            _activeElements = new Vector.<PerformanceElement>();
        }
        
        public function getSample(numFrames:Number):Sample
        {
            // create our result sample and zero its samples out so we can add in the
            // audio from performance events that intersect our time interval.
            //
            var sample:Sample = new Sample(descriptor, numFrames);
            
            var _stillActive:Vector.<PerformanceElement> = new Vector.<PerformanceElement>();
            var element:PerformanceElement;
            var i:Number;
            var j:Number;
            var c:Number;
            
            // Update the active element list with elements that intersect the time interval of interest.
            var elements:Vector.<PerformanceElement> = _performance.getElementsInRange(_position, _position + numFrames);
            for (i = 0; i < elements.length; i++)
            {
                elements[i].source.resetPosition();
                _activeElements.push(elements[i]);
            }

            // process currently active elements by copying the active section of their signal
            // into our result sample, noting whether they continue past this time window.
            //
            for each (element in _activeElements)
            {
                // First, determine the offset within our result where we'll put this element's first frame
                var activeOffset:Number = Math.max(0, element.start - _position);
                
                // And determine the number of frames for this element that can be processed in this chunk
                var activeLength:Number = Math.min(numFrames - activeOffset, element.end - (_position + activeOffset));
                
                // If anything to do, then add the element's signal into our result.
                if (activeLength > 0)
                {
                    var elementSample:Sample = element.source.getSample(activeLength);
                    for (c = 0; c < elementSample.channels; c++)
                    {
                        var sourceData:Vector.<Number> = elementSample.channelData[c];
                        var destData:Vector.<Number> = sample.channelData[c];
                        j = activeOffset;
                        for (i = 0; i < activeLength; i++)
                        {
                            destData[j++] += sourceData[i];
                        }
                    }
                }
                
                // If this element is still going to be active in the next batch of frames, take note of that.
                if (element.end > _position + numFrames)
                {
                    _stillActive.push(element);
                }
            }
            
            _activeElements = _stillActive;
            _position += numFrames;

            return sample;
        }
        
        public function clone():IAudioSource
        {
            return new AudioPerformer(_performance.clone());
        }
    }
}