////////////////////////////////////////////////////////////////////////////////
//
//  NOTEFLIGHT LLC
//  Copyright 2007-2008 Noteflight LLC
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package com.noteflight.standingwave2.elements
{
    /**
     * An implementation of IAudioSource represents a source of audio data with
     * characteristics described by an AudioDescriptor, and a definite number of sample
     * frames.  Calling <code>getSample()</code> retrieves a range of data from the
     * audio source; this ability to process data in ranges permits efficient time-slicing
     * of audio processing in the Flash Player so that CPU intensive operations do not
     * tie up the event loop.
     */
    public interface IAudioSource
    {
        /**
         * The AudioDescriptor describing the audio characteristics of this source.
         */
        function get descriptor():AudioDescriptor;

        /**
         * Get the number of sample frames in this source.
         */
        function get frameCount():Number;

        function get position():Number;

        function resetPosition():void;
        
        function getSample(numFrames:Number):Sample;
        
        function clone():IAudioSource;
    }
}