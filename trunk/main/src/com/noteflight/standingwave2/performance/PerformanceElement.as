////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.performance
{
    import com.noteflight.standingwave2.elements.IAudioSource;
    
    /**
     * A PerformanceElement is an IAudioSource with a specific start index in sample frames.
     */
    public class PerformanceElement
    {
        private var _source:IAudioSource;
        private var _start:Number;
        
        /**
         * Create a PerformanceElement that renders the given source at a particular time onset. 
         * @param start a time onset within the performance in seconds from the time origin
         * @param source an instance of IAudioSource
         * 
         */
        public function PerformanceElement(startTime:Number, source:IAudioSource)
        {
            _start = Math.floor(startTime * source.descriptor.rate);
            _source = source;
        }
               
        /**
         * The underlying audio source. 
         */
        public function get source():IAudioSource
        {
            return _source;
        }
        
        /**
         * The starting time frame offset for the audio in this source 
         */
        public function get start():Number
        {
            return _start;
        }
        
        /**
         * The ending time frame offset for the audio in this source 
         */
        public function get end():Number
        {
            return _start + _source.frameCount;
        }

        /**
         * The starting time offset in seconds
         */
        public function get startTime():Number
        {
            return _start / source.descriptor.rate;
        }
        
        /**
         * The ending time offset in seconds
         */
        public function get endTime():Number
        {
            return end / source.descriptor.rate;
        }
    }
}